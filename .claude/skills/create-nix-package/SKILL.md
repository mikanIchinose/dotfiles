---
name: create-nix-package
description: nix/packages/ 配下にカスタムNixパッケージを作成する。「nixパッケージを作って」「パッケージを追加して」「バイナリパッケージを追加して」と依頼された際に使用。
---

## ビルド方式の選択

| 言語/形式 | builder | 依存ハッシュ属性 |
|-----------|---------|----------------|
| Go | `buildGoModule` | `vendorHash` |
| Rust | `rustPlatform.buildRustPackage` | `cargoHash`（→ `references/rust.md` を参照） |
| Node.js (npm) | `buildNpmPackage` | `npmDepsHash` |
| プリビルドバイナリ | `stdenv.mkDerivation` + `fetchurl` | なし（→ `references/binary.md` を参照） |
| シェルスクリプト | `stdenv.mkDerivation` + `fetchFromGitHub` | なし |

**プリビルドバイナリの場合は `references/binary.md` を読んでその手順に従うこと。**
**Rust の場合は `references/rust.md` を読んでその手順に従うこと。**
**Go の場合は `create-nix-go-package` スキルを使うこと。**
**npm の場合は `create-nix-npm-package-v2` スキルを使うこと。**
**シェルスクリプトの場合は `create-nix-script-package` スキルを使うこと。**

## Workflow

### 1. 最新バージョンを確認

```bash
gh api repos/<owner>/<repo>/releases/latest --jq '{tag_name}'
```

### 2. nixpkgsに既存パッケージがないか確認

```bash
nix eval nixpkgs#<pname>.version 2>/dev/null
```

**存在する場合は、カスタムパッケージを作成する前にユーザーに確認する。**
nixpkgs 版で十分な場合は `home-manager.nix` に追加するだけでよく、カスタムパッケージは不要。

- nixpkgs のバージョンと最新バージョンの差分をユーザーに提示する
- 「nixpkgs 版で十分か？最新版が必要か？」を確認してから次のステップに進む

カスタムパッケージが必要な場合のみステップ3以降に進む。
nixpkgs 版を使う場合はステップ7（home-manager.nix に追加）のみ実施する。

### 3. default.nix を作成

`nix/packages/<pname>/default.nix` を作成する。

#### 慣習（既存パッケージとの一貫性）

- `src` の revision は `tag = "v${version}"` を使う
- `meta` に `changelog` フィールドは不要
- `meta.maintainers` は不要

#### テンプレート (Rust)

```nix
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
    tag = "v${version}";
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

#### テンプレート (Go)

```nix
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
    tag = "v${version}";
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

### 4. flake.nix に登録

`perSystem` と overlay の両方に追加する:

```nix
# perSystem
packages.<pname> = pkgs.callPackage ./nix/packages/<pname> { };

# overlay (overlays-configuration の local packages)
<pname> = final.callPackage ./nix/packages/<pname> { };
```

### 5. fakeHash でビルドして正しいハッシュを取得

```bash
nix build .#<pname> 2>&1 | grep "got:"
```

エラー出力の `got: sha256-...` を `default.nix` の `lib.fakeHash` と置き換える。
`src` の hash と 依存ハッシュ（`cargoHash` など）は別々に取得する（片方ずつ `lib.fakeHash` にしてビルドする）。

### 6. update.sh を作成

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

### 7. home-manager.nix に追加

`nix/home-manager.nix` の適切なリストに追加する:

| カテゴリ | 追加先リスト |
|---------|------------|
| Vimプラグイン関連 | `devtools-vim` |
| LSP | `lsp` |
| Linter/Formatter | `linter` |
| Go ツール | `devtools-go` |
| 自作パッケージ | `selfPackages` |
| その他ユーティリティ | `utility` |

## 完了チェックリスト

- [ ] `nix/packages/<pname>/default.nix` を作成
- [ ] `flake.nix` の `perSystem` に追加
- [ ] `flake.nix` の overlay に追加
- [ ] `nix build .#<pname>` が成功する
- [ ] `nix/packages/<pname>/update.sh` を作成・実行権限付与
- [ ] `nix/home-manager.nix` の適切なリストに追加
