# Nix パッケージ生成ツール調査

調査日: 2026-02-23

## 背景

Nix パッケージを以下のデータソースから生成する便利なツールを調査した。

- Binary (プリビルドバイナリ)
- Script (シェルスクリプト等)
- Go
- Rust
- npm

## 汎用ツール

### nix-init

- URL: https://github.com/nix-community/nix-init
- メンテナー: @figsoda (nix-community)
- 概要: URLからNixパッケージ定義を自動生成するCLIツール
- 特徴:
  - ハッシュプリフェッチ (`nurl` ベース、`cargoHash` / `vendorHash` 対応)
  - 依存推論 (Rust, Go, Python)
  - ライセンス自動検出
  - インタラクティブプロンプト (ファジー補完付き)
  - `--headless` モードあり (CI向け)
- 対応ビルダー:
  - `stdenv.mkDerivation`
  - `buildRustPackage`
  - `buildPythonApplication` / `buildPythonPackage`
  - `buildGoModule`
- 対応フェッチャー:
  - `fetchCrate`, `fetchFromGitHub`, `fetchFromGitLab`, `fetchFromGitea`, `fetchPypi`
  - その他 `nurl` がサポートする全フェッチャー
- 注意: 生成されたパッケージはそのままでは動かないことが多く、手動調整が必要

### nurl

- URL: https://github.com/nix-community/nurl
- 概要: リポジトリURLからNixのfetcher呼び出しコードを生成
- nix-init の内部でも使用されている

### dream2nix

- URL: https://github.com/nix-community/dream2nix
- ドキュメント: https://dream2nix.dev/
- 概要: 複数言語エコシステム向けの統一パッケージングフレームワーク
- 対応: Node.js, Rust, Python 等
- 現状: drv-parts へのリファクタリング中で API が不安定
- NGI Assure Fund (NLnet / EU) の助成を受けている

## データソース別の推奨ツール・手法

### Binary (プリビルドバイナリ)

| 項目 | 内容 |
|------|------|
| 自動生成ツール | なし |
| 推奨手法 | `stdenv.mkDerivation` + `autoPatchelfHook` (Linux) / `installPhase` のみ (macOS) |
| 備考 | テンプレートベースで手動作成が現実的 |

典型的なパターン:

```nix
stdenv.mkDerivation {
  pname = "example";
  version = "1.0.0";
  src = fetchurl { url = "..."; hash = "..."; };
  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  installPhase = ''
    install -Dm755 example $out/bin/example
  '';
}
```

### Script (シェルスクリプト等)

| 項目 | 内容 |
|------|------|
| 自動生成ツール | なし |
| 推奨手法 | `writeShellApplication` または `stdenv.mkDerivation` |
| 備考 | テンプレートベースで手動作成が現実的 |

典型的なパターン:

```nix
writeShellApplication {
  name = "example";
  runtimeInputs = [ coreutils jq ];
  text = builtins.readFile ./example.sh;
}
```

### Go

| 項目 | 内容 |
|------|------|
| 自動生成ツール | **nix-init** (推奨) |
| ビルダー | `buildGoModule` |
| 代替ツール | [gomod2nix](https://github.com/nix-community/gomod2nix) (go1.17ベースで古い) |
| 備考 | nix-init がURLから `vendorHash` 含め自動生成可能 |

```sh
nix-init -u https://github.com/owner/repo
# → buildGoModule ベースのパッケージ定義を生成
```

### Rust

| 項目 | 内容 |
|------|------|
| 自動生成ツール | **nix-init** (推奨) |
| ビルダー | `buildRustPackage` (nixpkgs標準) |
| 代替ツール | [naersk](https://github.com/nix-community/naersk), [crane](https://github.com/ipetkov/crane), [cargo2nix](https://github.com/cargo2nix/cargo2nix) |
| 備考 | nix-init がURLから `cargoHash` 含め自動生成可能 |

代替ツール比較:

| ツール | 特徴 |
|--------|------|
| naersk | 設定不要、Cargo.lock から直接ビルド、サンドボックスフレンドリー |
| crane | 増分キャッシュ、依存と本体を分離ビルド |
| cargo2nix | クロスコンパイル対応、代替レジストリ対応 |

### npm

| 項目 | 内容 |
|------|------|
| 自動生成ツール | [node2nix](https://github.com/svanderburg/node2nix), [dream2nix](https://dream2nix.dev/) |
| 代替ツール | yarn2nix, napalm (package-lock.json直接インポート) |
| 備考 | nix-init は npm 非対応。node2nix は3ファイル生成 (node-packages.nix, node-env.nix, default.nix) |

```sh
node2nix -i node-packages.json
# → node-packages.nix, node-env.nix, default.nix を生成
```

## このリポジトリでの採用判断

### npm → 不採用 (node2nix, dream2nix とも)

- nixpkgs 標準の `buildNpmPackage` で既に `copilot-language-server`, `gh-actions-language-server` が動いている
- `buildNpmPackage` は `package.json` + `package-lock.json` を置いて `npmDepsHash` を指定するだけでシンプル
- node2nix は3ファイル自動生成で diff がノイジー、かつ nixpkgs では `buildNpmPackage` への移行が進んでいる
- dream2nix は API が不安定

### Go / Rust → 不採用 (nix-init)

- nix-init は新規パッケージの初期生成ツールであり、既存パッケージの管理には関係しない
- Go パッケージ (gwq, covpeek, slack-reminder) は既に `buildGoModule` で簡潔に書けており、nix-init の出力と実質同じ
- Rust パッケージ (mocword, rogcat) はソースビルドではなくプリビルドバイナリ配布のため、nix-init の `buildRustPackage` 生成は対象外
- 新規パッケージ追加の頻度が低く、`create-nix-package` スキルとテンプレートで十分対応可能
- ハッシュ計算も `nix-prefetch-url` や `update.sh` で対応済み

## まとめ

| データソース | 自動生成 | 推奨アプローチ |
|-------------|---------|---------------|
| Binary | 不可 | テンプレートから手動作成 |
| Script | 不可 | テンプレートから手動作成 |
| Go | **nix-init** | `nix-init -u <URL>` → 手動調整 |
| Rust | **nix-init** | `nix-init -u <URL>` → 手動調整 |
| npm | **buildNpmPackage** (nixpkgs標準) | `package.json` + `package-lock.json` + `npmDepsHash` |

- **nix-init** が Go/Rust で最も有力。URLを渡すだけでパッケージ定義を生成できる
- Binary/Script は自動生成ツールが存在せず、テンプレートベースの手動作成が現実的
- npm は nixpkgs 標準の `buildNpmPackage` が推奨。node2nix は古いアプローチ
- **このリポジトリでは**いずれのツールも現時点では不要。既存のテンプレート・スキルで十分対応できている

## 参考リンク

- [nix-init](https://github.com/nix-community/nix-init)
- [nurl](https://github.com/nix-community/nurl)
- [dream2nix](https://github.com/nix-community/dream2nix)
- [node2nix](https://github.com/svanderburg/node2nix)
- [naersk](https://github.com/nix-community/naersk)
- [crane](https://github.com/ipetkov/crane)
- [cargo2nix](https://github.com/cargo2nix/cargo2nix)
- [gomod2nix](https://github.com/nix-community/gomod2nix)
- [NixOS Wiki - Language-specific package helpers](https://nixos.wiki/wiki/Language-specific_package_helpers)
- [awesome-nix](https://github.com/nix-community/awesome-nix)
