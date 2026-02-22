---
name: create-nix-package
description: |
  Nixパッケージを作成する。Go/Rust/npm/バイナリ/シェルスクリプトに対応。
  「nixパッケージを作って」「パッケージを追加して」「Go パッケージを追加」「npm パッケージを追加」「スクリプトをパッケージ化」と依頼された際に使用。
---

## ビルド方式の選択

| 言語/形式 | builder | 依存ハッシュ属性 | 詳細 |
|-----------|---------|----------------|------|
| Go | `buildGoModule` | `vendorHash` | `references/go.md` |
| Rust | `rustPlatform.buildRustPackage` | `cargoHash` | `references/rust.md` |
| Node.js (npm) | `buildNpmPackage` | `npmDepsHash` | `references/npm.md` |
| プリビルドバイナリ | `stdenv.mkDerivation` + `fetchurl` | なし | `references/binary.md` |
| シェルスクリプト | `stdenv.mkDerivation` + `fetchFromGitHub` | なし | `references/script.md` |

**ビルド方式を特定したら、対応する `references/<type>.md` を読んでその手順に従うこと。**

## 共通ワークフロー

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

### 3. init スクリプトでテンプレート生成

各ビルド方式の `references/<type>.md` に記載された init スクリプトを実行する。

### 4. flake.nix に登録

`perSystem` と overlay の両方に追加する:

```nix
# perSystem
packages.<pname> = pkgs.callPackage ./nix/packages/<pname> { };

# overlay (overlays-configuration の local packages)
<pname> = final.callPackage ./nix/packages/<pname> { };
```

### 5. git add で Nix に認識させる

flake モードでは Git にトラッキングされていないファイルは参照できない。
init スクリプトは自動で `git add` するが、flake.nix の変更も追加する:

```bash
git add nix/packages/<pname> flake.nix
```

### 6. fakeHash でビルドして正しいハッシュを取得

```bash
nix build .#<pname> 2>&1 | grep "got:"
```

エラー出力の `got: sha256-...` を `default.nix` の `lib.fakeHash` と置き換える。
`src` の hash と依存ハッシュ（`cargoHash` / `vendorHash` / `npmDepsHash`）は別々に取得する（片方ずつ `lib.fakeHash` にしてビルドする）。

詳細は各 `references/<type>.md` を参照。

### 7. nix build でビルド確認

```bash
nix build .#<pname> 2>&1
```

失敗した場合はエラーメッセージに応じてオプション調整を行う（各 `references/<type>.md` 参照）。

### 8. update.sh を作成

init スクリプトが自動生成する。生成されなかった場合:

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

### 9. home-manager.nix に追加

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

- [ ] `nix eval nixpkgs#<pname>.version` で nixpkgs に既存パッケージがないか確認
- [ ] init スクリプトでテンプレート生成
- [ ] `flake.nix` の `perSystem` に追加
- [ ] `flake.nix` の overlay に追加
- [ ] `git add` で Nix に認識させる
- [ ] ハッシュを取得・置換
- [ ] `nix build .#<pname>` が成功する
- [ ] `nix/packages/<pname>/update.sh` を作成・実行権限付与
- [ ] `nix/home-manager.nix` の適切なリストに追加
