---
name: create-npm-package
description: buildNpmPackage を使った Nix パッケージの作成手順。「npm パッケージを追加」「buildNpmPackage でパッケージ作成」と依頼された際に使用
---

# buildNpmPackage による npm パッケージの追加

npm レジストリのパッケージを Nix で管理するための手順。

## 目次

1. [パッケージディレクトリの作成](#1-パッケージディレクトリの作成)
2. [package.json の作成](#2-packagejson-の作成)
3. [package-lock.json の生成](#3-package-lockjson-の生成)
4. [npmDepsHash の計算](#4-npmdepshash-の計算)
5. [default.nix の作成](#5-defaultnix-の作成)
6. [flake.nix の overlay に追加](#6-flakenix-の-overlay-に追加)
7. [home-manager.nix で使用](#7-home-managernix-で使用)
8. [git に追加してビルド検証](#8-git-に追加してビルド検証)
9. [更新スクリプト](#更新スクリプト)
10. [実行ファイルのパス確認](#実行ファイルのパス確認)

---

## 1. パッケージディレクトリの作成

```bash
mkdir -p nix/packages/<package-name>
cd nix/packages/<package-name>
```

## 2. package.json の作成

```json
{
  "name": "<package-name>-wrapper",
  "version": "<version>",
  "private": true,
  "dependencies": {
    "<npm-package-name>": "<version>"
  }
}
```

**スコープ付きパッケージの例** (`@github/copilot-language-server`):
```json
{
  "name": "copilot-language-server-wrapper",
  "version": "1.411.0",
  "private": true,
  "dependencies": {
    "@github/copilot-language-server": "1.411.0"
  }
}
```

## 3. package-lock.json の生成

```bash
npm install --package-lock-only
```

## 4. npmDepsHash の計算

```bash
nix shell nixpkgs#prefetch-npm-deps -c prefetch-npm-deps package-lock.json
```

出力例: `sha256-bXwMO2l89RVDPgFu/OcCZG9P6ptp/PmglvvUtqhssLY=`

## 5. default.nix の作成

```nix
{
  lib,
  buildNpmPackage,
  nodejs_24,
}:

buildNpmPackage {
  pname = "<package-name>";
  version = "<version>";

  src = ./.;

  npmDepsHash = "<計算したハッシュ>";

  nodejs = nodejs_24;

  dontNpmBuild = true;
  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/node_modules
    cp -r node_modules/<npm-package-name> $out/lib/node_modules/
    ln -s $out/lib/node_modules/<npm-package-name>/bin/<executable> $out/bin/<command-name>

    runHook postInstall
  '';

  meta = with lib; {
    description = "<説明>";
    homepage = "<URL>";
    license = licenses.mit;
    mainProgram = "<command-name>";
  };
}
```

**スコープ付きパッケージの installPhase**:
```nix
installPhase = ''
  runHook preInstall

  mkdir -p $out/bin $out/lib/node_modules/@github
  cp -r node_modules/@github/copilot-language-server $out/lib/node_modules/@github/
  ln -s $out/lib/node_modules/@github/copilot-language-server/dist/language-server.js $out/bin/copilot-language-server

  runHook postInstall
'';
```

## 6. flake.nix の overlay に追加

```nix
# flake.nix の overlay セクション
(final: prev: {
  # 既存のパッケージ...
  <package-name> = final.callPackage ./nix/packages/<package-name> { };
})
```

## 7. home-manager.nix で使用

```nix
# パッケージリストに追加
lsp = with pkgs; [
  <package-name>
];
```

## 8. git に追加してビルド検証

```bash
git add nix/packages/<package-name>
nix build .#darwinConfigurations.mikan.system --dry-run
```

---

## 更新スクリプト

既存パッケージの更新には `nix/packages/update-npm-package.sh` を使用:

```bash
./nix/packages/update-npm-package.sh <package-name>
```

## 実行ファイルのパス確認

npm パッケージの実行ファイルの場所を確認:

```bash
# package.json の bin フィールドを確認
npm view <npm-package-name> bin

# または展開して確認
npm pack <npm-package-name>
tar -tzf <npm-package-name>-*.tgz | grep -E '(bin/|\.js$)'
```
