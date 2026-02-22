# プリビルドバイナリのNixパッケージ化

GitHubリリース等で配布されるプリビルドバイナリを `stdenv.mkDerivation` + `fetchurl` でパッケージ化する手順。

> まず `nix eval nixpkgs#<pname>.version 2>/dev/null` で nixpkgs に既存パッケージがないか確認する。

実例: [`nix/packages/rogcat/default.nix`](../nix/packages/rogcat/default.nix)

---

## テンプレート（単一アーキテクチャ）

```nix
# nix/packages/<pname>/default.nix
{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "<pname>";
  version = "<version>";

  src = fetchurl {
    url = "https://github.com/<owner>/<repo>/releases/download/v${version}/<pname>-aarch64-apple-darwin.tar.gz";
    hash = "<hash>";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp <pname> $out/bin/
  '';

  meta = with lib; {
    description = "<description>";
    homepage = "https://github.com/<owner>/<repo>";
    license = licenses.mit;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "<pname>";
  };
}
```

---

## テンプレート（マルチアーキテクチャ）

複数のプラットフォームに対応する場合、`stdenv.hostPlatform.system` でURLとハッシュを切り替える。

```nix
{
  lib,
  stdenv,
  fetchurl,
}:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/<owner>/<repo>/releases/download/v${version}/<pname>-aarch64-apple-darwin.tar.gz";
      hash = "<hash-aarch64-darwin>";
    };
    "x86_64-linux" = {
      url = "https://github.com/<owner>/<repo>/releases/download/v${version}/<pname>-x86_64-unknown-linux-gnu.tar.gz";
      hash = "<hash-x86_64-linux>";
    };
  };
  version = "<version>";
  src = sources.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation {
  pname = "<pname>";
  inherit version;

  src = fetchurl {
    inherit (src) url hash;
  };

  installPhase = ''
    mkdir -p $out/bin
    cp <pname> $out/bin/
  '';

  meta = with lib; {
    description = "<description>";
    homepage = "https://github.com/<owner>/<repo>";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "<pname>";
  };
}
```

---

## ハッシュの取得

`nix store prefetch-file` でダウンロードURLのハッシュを取得する。

```bash
nix store prefetch-file --json "https://github.com/<owner>/<repo>/releases/download/v<version>/<pname>-aarch64-apple-darwin.tar.gz" | jq -r '.hash'
```

マルチアーキテクチャの場合は各URLについてそれぞれハッシュを取得する。

---

## アーカイブ展開の扱い

`fetchurl` で取得した tarball / zip は Nix が自動展開する。展開後のファイル配置に応じて `installPhase` を調整する。

### パターン1: バイナリが展開ルートに直接ある

```nix
installPhase = ''
  mkdir -p $out/bin
  cp <pname> $out/bin/
'';
```

### パターン2: バイナリがサブディレクトリにある

展開後に `<pname>-v<version>/bin/<pname>` のようなパスにバイナリがある場合:

```nix
installPhase = ''
  mkdir -p $out/bin
  cp <pname>-v${version}/bin/<pname> $out/bin/
'';
```

### パターン3: 複数ファイルのインストール

バイナリに加えてシェル補完ファイル等を含む場合:

```nix
installPhase = ''
  mkdir -p $out/bin
  cp bin/<pname> $out/bin/

  mkdir -p $out/share/zsh/site-functions
  cp completions/_<pname> $out/share/zsh/site-functions/

  mkdir -p $out/share/fish/vendor_completions.d
  cp completions/<pname>.fish $out/share/fish/vendor_completions.d/
'';
```

### パターン4: 自動展開を無効にする

zip/tarball として扱わず、ダウンロードしたファイルをそのままバイナリとして使う場合:

```nix
src = fetchurl {
  url = "...";
  hash = "...";
};

dontUnpack = true;

installPhase = ''
  mkdir -p $out/bin
  install -m 755 $src $out/bin/<pname>
'';
```

---

## Linux向け動的リンク（autoPatchelfHook）

Linux向けのプリビルドバイナリは動的リンクライブラリに依存していることが多い。NixOS/Nix環境では標準パスにライブラリがないため、`autoPatchelfHook` で自動パッチを適用する。

```nix
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  # 依存ライブラリを追加
  glibc,
  openssl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "<pname>";
  version = "<version>";

  src = fetchurl {
    url = "...";
    hash = "...";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glibc
    openssl
    zlib
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp <pname> $out/bin/
  '';

  meta = with lib; {
    description = "<description>";
    homepage = "https://github.com/<owner>/<repo>";
    license = licenses.mit;
    platforms = [ "aarch64-darwin" "x86_64-linux" ];
    mainProgram = "<pname>";
  };
}
```

必要なライブラリは `ldd <binary>` や `file <binary>` で確認できる。macOS (darwin) のバイナリには `autoPatchelfHook` は不要。

---

## flake.nix への登録

`perSystem` と overlay の両方に追加する:

```nix
# perSystem
packages.<pname> = pkgs.callPackage ./nix/packages/<pname> { };

# overlays-configuration の local packages
<pname> = final.callPackage ./nix/packages/<pname> { };
```

---

## update.sh の作成

プリビルドバイナリは `nix-update` が使えないため、手動でバージョンとハッシュを更新するスクリプトを作成する。

### 単一アーキテクチャ

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

LATEST=$(gh release view --repo <owner>/<repo> --json tagName -q '.tagName | ltrimstr("v")')
CURRENT=$(sed -n 's/.*version = "\(.*\)".*/\1/p' default.nix)
[ "$LATEST" = "$CURRENT" ] && echo "<pname> is up to date ($CURRENT)" && exit 0

echo "Updating <pname>: $CURRENT -> $LATEST"
URL="https://github.com/<owner>/<repo>/releases/download/v${LATEST}/<pname>-aarch64-apple-darwin.tar.gz"
HASH=$(nix store prefetch-file --json "$URL" | jq -r '.hash')
sed -i '' "s/version = \".*\"/version = \"$LATEST\"/" default.nix
sed -i '' "s|hash = \".*\"|hash = \"$HASH\"|" default.nix
```

### マルチアーキテクチャ

ハッシュが複数ある場合は、各アーキテクチャのURLを順番に処理する。`sed` での置換がユニークになるよう工夫が必要。

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

LATEST=$(gh release view --repo <owner>/<repo> --json tagName -q '.tagName | ltrimstr("v")')
CURRENT=$(sed -n 's/.*version = "\(.*\)".*/\1/p' default.nix | head -1)
[ "$LATEST" = "$CURRENT" ] && echo "<pname> is up to date ($CURRENT)" && exit 0

echo "Updating <pname>: $CURRENT -> $LATEST"

# aarch64-darwin
URL_DARWIN="https://github.com/<owner>/<repo>/releases/download/v${LATEST}/<pname>-aarch64-apple-darwin.tar.gz"
HASH_DARWIN=$(nix store prefetch-file --json "$URL_DARWIN" | jq -r '.hash')

# x86_64-linux
URL_LINUX="https://github.com/<owner>/<repo>/releases/download/v${LATEST}/<pname>-x86_64-unknown-linux-gnu.tar.gz"
HASH_LINUX=$(nix store prefetch-file --json "$URL_LINUX" | jq -r '.hash')

# default.nix を再生成するか、nix ファイル内のハッシュを個別に置換する
sed -i '' "s/version = \".*\"/version = \"$LATEST\"/" default.nix
# ハッシュの置換はファイル構造に依存するため、必要に応じて調整する
```

スクリプト作成後、実行権限を付与する:

```bash
chmod +x nix/packages/<pname>/update.sh
```

---

## home-manager.nix への追加

`nix/home-manager.nix` の適切なリストに追加する:

| カテゴリ | 追加先 |
|---------|--------|
| 自作・カスタムパッケージ | `selfPackages` |
| CLIユーティリティ | `utility` |
| 開発ツール全般 | `devtools` |
| LSP | `lsp` |
| Linter/Formatter | `linter` |

---

## 完了チェックリスト

- [ ] `nix eval nixpkgs#<pname>.version` で nixpkgs に既存パッケージがないか確認
- [ ] `nix/packages/<pname>/default.nix` を作成
- [ ] `flake.nix` の `perSystem` に追加
- [ ] `flake.nix` の overlay に追加
- [ ] `nix build .#<pname>` が成功する
- [ ] `nix/packages/<pname>/update.sh` を作成・実行権限付与
- [ ] `nix/home-manager.nix` の適切なリストに追加
