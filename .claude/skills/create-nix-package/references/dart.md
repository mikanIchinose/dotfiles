## Dart パッケージ向けワークフロー

### テンプレートを一括生成

`init-dart.sh` がリリース情報取得・ファイル生成を一括で行う。
ハッシュは `lib.fakeHash` で仮入力される。

```bash
bash .claude/skills/create-nix-package/scripts/init-dart.sh <pname> <owner> <repo> [subdir]
```

- `<pname>`: Nix パッケージ名（例: `flutterfire-cli`）
- `<owner>/<repo>`: GitHub リポジトリ（例: `invertase/flutterfire`）
- `[subdir]`: モノレポの場合のサブディレクトリ（例: `packages/flutterfire_cli`）

生成されるファイル:
- `nix/packages/<pname>/default.nix`
- `nix/packages/<pname>/pubspec.lock.json`
- `nix/packages/<pname>/update.sh`

### 依存管理の仕組み

Dart は Go/Rust/npm と異なり、**単一の依存ハッシュを持たない**。
代わりに `pubspec.lock` を JSON に変換した `pubspec.lock.json` をコミットし、
`lib.importJSON ./pubspec.lock.json` で読み込む。

pub2nix が JSON から各依存を個別にフェッチする。

### ハッシュを取得（1段階）

Dart パッケージでは `src.hash` のみ取得が必要。

```bash
nix build .#<pname> 2>&1 | grep "got:"
```

出力の `got: sha256-...` を `default.nix` の `src.hash` (`lib.fakeHash`) と置き換える。

### pubspec.lock.json の生成

init スクリプトがソースを clone して自動生成するが、手動で行う場合:

```bash
yq eval --output-format=json --prettyPrint pubspec.lock > pubspec.lock.json
```

`yq` は `nix run nixpkgs#yq-go` で利用可能。

### Git 依存がある場合

`pubspec.lock` に Git ソースの依存が含まれている場合、`gitHashes` 属性で各パッケージのハッシュを指定する:

```nix
gitHashes = {
  some_package = "sha256-AAAA...";
};
```

ハッシュが不足している場合、ビルドエラーにパッケージ名と必要なハッシュが表示される。

### モノレポの場合

サブディレクトリにパッケージがある場合は `sourceRoot` を使う:

```nix
sourceRoot = "${src.name}/<subdir>";
```

`dependency_overrides` がある場合は `preBuild` で削除する:

```nix
preBuild = ''
  yq eval 'del(.dependency_overrides)' -i pubspec.yaml
'';
```

### オプション調整

| オプション | 用途 | 例 |
|-----------|------|-----|
| `dartCompileFlags` | `dart compile` への追加フラグ | `[ "--define=version=${version}" ]` |
| `dartOutputType` | 出力タイプ | `"exe"` (デフォルト), `"aot-snapshot"`, `"jit-snapshot"` |
| `dartEntryPoints` | バイナリ名→ソースファイルのマッピング | `{ "bin/tool" = "bin/main.dart"; }` |
| `pubGetScript` | `pub get` コマンドの上書き | - |
| `customSourceBuilders` | 特定パッケージのビルドカスタマイズ | - |

#### 依存関係

| オプション | 用途 | 例 |
|-----------|------|-----|
| `nativeBuildInputs` | ビルド時のみ必要な依存 | `[ yq-go ]` |
| `buildInputs` | リンク時に必要なライブラリ | - |

### 完了チェックリスト

- [ ] `init-dart.sh` でテンプレート生成
- [ ] `src.hash` を取得・置換
- [ ] Git 依存がある場合は `gitHashes` を設定
- [ ] モノレポの場合は `sourceRoot` と `dependency_overrides` 削除を確認
- [ ] `nix build .#<pname>` が成功する
