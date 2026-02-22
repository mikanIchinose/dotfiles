# Rust製ツールのNixパッケージ化

## ビルド方式の選択

| 方式 | 使用場面 |
|------|---------|
| `rustPlatform.buildRustPackage` | ソースからビルドする（推奨） |
| `stdenv.mkDerivation` + `fetchurl` | GitHubリリースにバイナリがある場合 |

> まず `nix eval nixpkgs#<pname>.version 2>/dev/null` で nixpkgs に既存パッケージがないか確認する。

---

## 方式1: ソースからビルド（`buildRustPackage`）

### テンプレート

```nix
# nix/packages/<pname>/default.nix
{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "<pname>";
  version = "<version>";

  src = fetchFromGitHub {
    owner = "<owner>";
    repo = "<repo>";
    rev = "v${version}";
    hash = lib.fakeHash;
    fetchSubmodules = true;
  };

  cargoHash = lib.fakeHash;

  doCheck = false;

  meta = with lib; {
    description = "<description>";
    homepage = "https://github.com/<owner>/<repo>";
    license = licenses.mit;
    mainProgram = "<pname>";
  };
}
```

実例: [`nix/packages/tree-sitter-cli/default.nix`](../nix/packages/tree-sitter-cli/default.nix)

### ハッシュの取得

`lib.fakeHash` を仮入力してビルドすると、エラー出力に正しいハッシュが表示される。
`src` の `hash` と `cargoHash` は **別々に** 取得する（片方ずつ置き換えてビルドする）。

```bash
# 1. src の hash を取得（cargoHash は lib.fakeHash のまま）
nix build .#<pname> 2>&1 | grep "got:"
# → got: sha256-XXXX...  を hash = に設定

# 2. cargoHash を取得（src の hash は確定済み）
nix build .#<pname> 2>&1 | grep "got:"
# → got: sha256-YYYY...  を cargoHash = に設定
```

### 主なオプション

| オプション | 用途 |
|-----------|------|
| `doCheck = false` | テストをスキップ（ビルド時間短縮・環境依存回避） |
| `buildNoDefaultFeatures = true` | デフォルト機能を無効化 |
| `buildFeatures = [ "feat" ]` | 追加機能を有効化 |
| `nativeBuildInputs` | ビルド時のみ必要な依存（例: `pkg-config`） |
| `buildInputs` | リンク時に必要なライブラリ（例: `openssl`） |
| `fetchSubmodules = true` | git submodule を含む場合に指定 |

### シェル補完を追加する場合

```nix
{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,  # 追加
}:

rustPlatform.buildRustPackage rec {
  # ...

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd <pname> \
      --bash <("$out/bin/<pname>" completions bash) \
      --zsh  <("$out/bin/<pname>" completions zsh) \
      --fish <("$out/bin/<pname>" completions fish)
  '';
}
```

---

## 方式2: プリビルドバイナリのインストール

GitHubリリースにアーキテクチャ別バイナリが公開されている場合に使用する。
ビルド不要だが、アーキテクチャごとに URL を管理する必要がある。

実例: [`nix/packages/rogcat/default.nix`](../nix/packages/rogcat/default.nix)

```nix
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
    hash = "sha256-...";
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

ハッシュ取得:

```bash
nix store prefetch-file --json "<url>" | jq -r '.hash'
```

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

`nix-update` を使った標準的なスクリプト:

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
pkg="$(basename "$(pwd)")"
nix run nixpkgs#nix-update -- --flake --override-filename "nix/packages/$pkg/default.nix" "$pkg"
```

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
