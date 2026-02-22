# Go製ツールのNixパッケージ化

## ビルド方式

| 方式 | 使用場面 |
|------|---------|
| `buildGoModule` | ソースからビルドする（推奨） |
| `stdenv.mkDerivation` + `fetchurl` | GitHubリリースにバイナリがある場合 |

> まず `nix eval nixpkgs#<pname>.version 2>/dev/null` で nixpkgs に既存パッケージがないか確認する。

---

## テンプレート

```nix
# nix/packages/<pname>/default.nix
{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "<pname>";
  version = "<version>";

  src = fetchFromGitHub {
    owner = "<owner>";
    repo = "<repo>";
    rev = "v${version}";
    hash = lib.fakeHash;
  };

  vendorHash = lib.fakeHash;

  meta = with lib; {
    description = "<description>";
    homepage = "https://github.com/<owner>/<repo>";
    license = licenses.mit;
    mainProgram = "<pname>";
  };
}
```

実例: [`nix/packages/gwq/default.nix`](../nix/packages/gwq/default.nix)

---

## vendorHash の取得

`lib.fakeHash` を仮入力してビルドすると、エラー出力に正しいハッシュが表示される。
`src` の `hash` と `vendorHash` は **別々に** 取得する（片方ずつ置き換えてビルドする）。

```bash
# 1. src の hash を取得（vendorHash は lib.fakeHash のまま）
nix build .#<pname> 2>&1 | grep "got:"
# → got: sha256-XXXX...  を hash = に設定

# 2. vendorHash を取得（src の hash は確定済み）
nix build .#<pname> 2>&1 | grep "got:"
# → got: sha256-YYYY...  を vendorHash = に設定
```

依存が vendored（`vendor/` ディレクトリがリポジトリに含まれている）場合は `vendorHash = null` とする。

---

## 主なオプション

### ビルド対象の制御

| オプション | 用途 | 例 |
|-----------|------|-----|
| `subPackages` | ビルド対象のパッケージを限定 | `[ "cmd/tool" ]` |
| `excludedPackages` | 除外するパッケージを指定 | `[ "cmd/debug" ]` |

### ビルドフラグ

| オプション | 用途 | 例 |
|-----------|------|-----|
| `ldflags` | リンカフラグ（バージョン埋め込み等） | `[ "-s" "-w" "-X main.Version=${version}" ]` |
| `tags` | ビルドタグ | `[ "netgo" "osusergo" ]` |

### CGO の無効化

CGO を使わないパッケージでは明示的に無効化できる:

```nix
CGO_ENABLED = 0;
```

### 依存関係

| オプション | 用途 | 例 |
|-----------|------|-----|
| `nativeBuildInputs` | ビルド時のみ必要な依存 | `[ pkg-config installShellFiles ]` |
| `buildInputs` | リンク時に必要なライブラリ | `[ openssl ]` |

### その他

| オプション | 用途 |
|-----------|------|
| `doCheck = false` | テストをスキップ（環境依存テストの回避） |
| `proxyVendor = true` | C ライブラリ依存や大文字小文字の衝突がある場合に使用 |
| `modPostBuild` | `go mod vendor` 後に実行するコマンド |

### シェル補完を追加する場合

```nix
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,  # 追加
}:

buildGoModule rec {
  # ...

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd <pname> \
      --bash <("$out/bin/<pname>" completion bash) \
      --zsh  <("$out/bin/<pname>" completion zsh) \
      --fish <("$out/bin/<pname>" completion fish)
  '';
}
```

> Go ツールの補完コマンドは `completion`（単数形）が多い。ツールごとに確認すること。

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
| Go開発ツール | `devtools-go` |
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
