# npm パッケージの Nix パッケージ化

## 概要

`buildNpmPackage` を使って npm レジストリのパッケージを Nix パッケージとしてビルドする。
このリポジトリでは `fetchFromGitHub` ではなく、ローカルに `package.json` / `package-lock.json` を配置して `src = ./.;` とする方式を採用している。

> まず `nix eval nixpkgs#<pname>.version 2>/dev/null` で nixpkgs に既存パッケージがないか確認する。

---

## パッケージディレクトリの構成

```
nix/packages/<pname>/
  default.nix        # Nix パッケージ定義
  package.json       # npm パッケージの依存宣言
  package-lock.json  # npm が生成するロックファイル
  update.sh          # バージョン更新スクリプト
```

実例: [`nix/packages/copilot-language-server/`](../nix/packages/copilot-language-server/)、[`nix/packages/gh-actions-language-server/`](../nix/packages/gh-actions-language-server/)

---

## 手順

### 1. package.json を作成

```json
{
  "name": "<pname>-wrapper",
  "version": "<version>",
  "private": true,
  "dependencies": {
    "<npm-package-name>": "<version>"
  }
}
```

- `name` はラッパーであることを示す `<pname>-wrapper` とする
- `private: true` で npm レジストリへの誤公開を防ぐ
- スコープ付きパッケージ（例: `@github/copilot-language-server`）はそのまま記述する

### 2. package-lock.json を生成

```bash
cd nix/packages/<pname>
npm install --package-lock-only
```

### 3. default.nix を作成

#### テンプレート

```nix
# nix/packages/<pname>/default.nix
{
  lib,
  buildNpmPackage,
  nodejs_24,
}:

buildNpmPackage {
  pname = "<pname>";
  version = "<version>";

  src = ./.;

  npmDepsHash = lib.fakeHash;

  nodejs = nodejs_24;

  dontNpmBuild = true;
  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/node_modules
    cp -r node_modules/<npm-package-name> $out/lib/node_modules/
    ln -s $out/lib/node_modules/<npm-package-name>/bin/<executable> $out/bin/<pname>

    runHook postInstall
  '';

  meta = with lib; {
    description = "<description>";
    homepage = "<homepage-url>";
    license = licenses.mit;
    mainProgram = "<pname>";
  };
}
```

#### テンプレートの補足

- **`src = ./.;`**: ローカルの `package.json` / `package-lock.json` をソースとして使う
- **`dontNpmBuild = true`**: ビルドスクリプトを実行しない（npm レジストリのパッケージはビルド済みのため）
- **`dontNpmInstall = true`**: `npm install` のインストールフェーズをスキップ
- **`installPhase`**: `node_modules` から必要なファイルを `$out` にコピーし、実行ファイルへの symlink を作成する
- **`nodejs = nodejs_24`**: Node.js のバージョンを明示的に指定する

#### スコープ付きパッケージの場合

`@scope/package-name` の場合、`installPhase` のパスを調整する:

```nix
installPhase = ''
  runHook preInstall

  mkdir -p $out/bin $out/lib/node_modules/@scope
  cp -r node_modules/@scope/<package-name> $out/lib/node_modules/@scope/
  ln -s $out/lib/node_modules/@scope/<package-name>/dist/<executable>.js $out/bin/<pname>
  chmod +x $out/bin/<pname>

  runHook postInstall
'';
```

### 4. flake.nix に登録

`perSystem` と overlay の両方に追加する:

```nix
# perSystem
packages.<pname> = pkgs.callPackage ./nix/packages/<pname> { };

# overlays-configuration の local packages
<pname> = final.callPackage ./nix/packages/<pname> { };
```

### 5. npmDepsHash を取得

```bash
nix build .#<pname> 2>&1 | grep "got:"
```

エラー出力の `got: sha256-...` を `default.nix` の `lib.fakeHash` と置き換える。

あるいは `prefetch-npm-deps` を使って直接取得することもできる:

```bash
nix shell nixpkgs#prefetch-npm-deps -c prefetch-npm-deps package-lock.json
```

### 6. ビルド確認

```bash
nix build .#<pname>
```

### 7. update.sh を作成

npm パッケージの更新スクリプトは `nix-update` ではなく、npm レジストリから最新バージョンを取得して `package.json`、`package-lock.json`、`default.nix` を更新する方式を使う。

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PKG="<npm-package-name>"
LATEST=$(npm view "$PKG" version)
CURRENT=$(jq -r '.version' package.json)
[ "$LATEST" = "$CURRENT" ] && echo "$PKG is up to date ($CURRENT)" && exit 0

echo "Updating $PKG: $CURRENT -> $LATEST"
jq --arg v "$LATEST" '.version = $v | .dependencies["<npm-package-name>"] = $v' package.json > package.json.tmp
mv package.json.tmp package.json
npm install --package-lock-only
NEW_HASH=$(nix run nixpkgs#prefetch-npm-deps -- package-lock.json 2>/dev/null)
sed -i '' "s/version = \".*\"/version = \"$LATEST\"/" default.nix
sed -i '' "s|npmDepsHash = \".*\"|npmDepsHash = \"$NEW_HASH\"|" default.nix
```

```bash
chmod +x nix/packages/<pname>/update.sh
```

> 注意: 共通ヘルパーの `nix/packages/update-npm-package.sh` も利用可能だが、`npmDepsHash` の自動更新は行わないため、パッケージ固有の `update.sh` を使うほうが便利。

### 8. home-manager.nix に追加

`nix/home-manager.nix` の適切なリストに追加する:

| カテゴリ | 追加先 |
|---------|--------|
| LSP | `lsp` |
| 自作・カスタムパッケージ | `selfPackages` |
| CLIユーティリティ | `utility` |
| 開発ツール全般 | `devtools` |
| Linter/Formatter | `linter` |

---

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

---

## 完了チェックリスト

- [ ] `nix eval nixpkgs#<pname>.version` で nixpkgs に既存パッケージがないか確認
- [ ] `nix/packages/<pname>/package.json` を作成
- [ ] `nix/packages/<pname>/package-lock.json` を生成（`npm install --package-lock-only`）
- [ ] `nix/packages/<pname>/default.nix` を作成
- [ ] `flake.nix` の `perSystem` に追加
- [ ] `flake.nix` の overlay に追加
- [ ] `npmDepsHash` を取得して `default.nix` に設定
- [ ] `nix build .#<pname>` が成功する
- [ ] `nix/packages/<pname>/update.sh` を作成・実行権限付与
- [ ] `nix/home-manager.nix` の適切なリストに追加
