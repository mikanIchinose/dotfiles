---
name: create-nix-npm-package-v2
description: buildNpmPackage を使った npm パッケージの Nix パッケージを作成する。「npm パッケージを追加」「buildNpmPackage でパッケージ作成」と依頼された際に使用。
---

## ワークフロー

### 1. テンプレートを一括生成

```bash
bash .claude/skills/create-nix-npm-package-v2/scripts/init-npm.sh <pname> <npm-package-name>
```

- `<pname>`: Nix パッケージ名（例: `copilot-language-server`）
- `<npm-package-name>`: npm レジストリ上のパッケージ名（例: `@github/copilot-language-server`）

生成されるファイル:
- `nix/packages/<pname>/default.nix`
- `nix/packages/<pname>/package.json`
- `nix/packages/<pname>/package-lock.json`
- `nix/packages/<pname>/update.sh`

### 2. flake.nix に登録

`perSystem` と overlay の両方に追加する:

```nix
# perSystem
packages.<pname> = pkgs.callPackage ./nix/packages/<pname> { };

# overlays-configuration の local packages
<pname> = final.callPackage ./nix/packages/<pname> { };
```

### 3. git add で Nix に認識させる

`src = ./.;` を使用しているため、Nix がファイルを認識するには git add が必要。

```bash
git add nix/packages/<pname> flake.nix
```

### 4. npmDepsHash を取得

```bash
nix build .#<pname> 2>&1 | grep "got:"
```

エラー出力の `got: sha256-...` を `default.nix` の `lib.fakeHash` と置き換える。

あるいは `prefetch-npm-deps` を使って直接取得:

```bash
nix shell nixpkgs#prefetch-npm-deps -c prefetch-npm-deps nix/packages/<pname>/package-lock.json
```

### 5. installPhase を調整

スクリプトが自動生成する `installPhase` は npm の `bin` フィールドに基づくが、パッケージによっては調整が必要。

**bin の確認方法:**

```bash
npm view <npm-package-name> bin --json
```

**スコープなしパッケージ** (`<pkg>`):
```nix
installPhase = ''
  runHook preInstall
  mkdir -p $out/bin $out/lib/node_modules
  cp -r node_modules/<pkg> $out/lib/node_modules/
  ln -s $out/lib/node_modules/<pkg>/bin/<executable> $out/bin/<pname>
  runHook postInstall
'';
```

**スコープ付きパッケージ** (`@scope/pkg`):
```nix
installPhase = ''
  runHook preInstall
  mkdir -p $out/bin $out/lib/node_modules/@scope
  cp -r node_modules/@scope/<pkg> $out/lib/node_modules/@scope/
  ln -s $out/lib/node_modules/@scope/<pkg>/bin/<executable> $out/bin/<pname>
  chmod +x $out/bin/<pname>
  runHook postInstall
'';
```

### 6. nix build でビルド確認

```bash
nix build .#<pname>
```

### 7. home-manager.nix に追加

`nix/home-manager.nix` の適切なリストに追加する:

| カテゴリ | 追加先 |
|---------|--------|
| LSP | `lsp` |
| 自作・カスタムパッケージ | `selfPackages` |
| CLIユーティリティ | `utility` |
| 開発ツール全般 | `devtools` |
| Linter/Formatter | `linter` |

## 主なオプション一覧

| オプション | 説明 | デフォルト |
|-----------|------|-----------|
| `npmDepsHash` | 依存関係の出力ハッシュ（必須） | - |
| `nodejs` | 使用する Node.js バージョン | nixpkgs のデフォルト |
| `dontNpmBuild` | ビルドスクリプトの実行をスキップ | `false` |
| `dontNpmInstall` | `npm install` をスキップ | `false` |
| `npmBuildScript` | 実行するビルドスクリプト名 | `"build"` |
| `npmFlags` | 全 npm コマンドに適用するフラグ | `[]` |
| `npmInstallFlags` | `npm ci` に適用するフラグ | `[]` |
| `npmBuildFlags` | `npm run build` に適用するフラグ | `[]` |
| `npmPackFlags` | `npm pack` に適用するフラグ | `[]` |
| `npmPruneFlags` | `npm prune` に適用するフラグ | `npmInstallFlags` と同じ |
| `makeCacheWritable` | npm キャッシュへの書き込みを許可 | `false` |
| `npmWorkspace` | ビルド対象のワークスペースディレクトリ | - |
| `forceGitDeps` | git 依存を強制的に許可 | `false` |

## 完了チェックリスト

- [ ] `nix eval nixpkgs#<pname>.version` で nixpkgs に既存パッケージがないか確認
- [ ] `init-npm.sh` でテンプレートを生成
- [ ] `flake.nix` の `perSystem` に追加
- [ ] `flake.nix` の overlay に追加
- [ ] `git add` で Nix に認識させる
- [ ] `npmDepsHash` を取得して `default.nix` に設定
- [ ] `installPhase` の bin パスを確認・調整
- [ ] `nix build .#<pname>` が成功する
- [ ] `nix/home-manager.nix` の適切なリストに追加
