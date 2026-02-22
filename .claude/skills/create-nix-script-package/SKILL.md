---
name: create-nix-script-package
description: シェルスクリプトの Nix パッケージを作成する（stdenv.mkDerivation + makeWrapper）。「スクリプトをパッケージ化」「シェルスクリプトを追加」と依頼された際に使用。
---

## ワークフロー

### 1. テンプレートを一括生成

`init-script.sh` がリリース情報取得・ファイル生成を一括で行う。
リリースタグの有無を自動判定し、適切なテンプレートを生成する。

```bash
bash .claude/skills/create-nix-script-package/scripts/init-script.sh <pname> <owner> <repo> [script-name]
```

- `script-name` を省略すると `pname` がスクリプト名として使われる
- **タグあり**: `version` はリリースタグから取得、`src.rev` は `tag = "v${version}"`
- **タグなし**: `version = "unstable-YYYY-MM-DD"`、`src.rev` は最新コミットハッシュ

### 2. 依存ツールを設定

生成された `default.nix` の TODO プレースホルダーを実際の依存に置き換える:

```nix
{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  # TODO: add runtime dependencies
  # gum,
  # git,
  # jq,
}:
```

- 関数引数に依存パッケージを追加
- `lib.makeBinPath [ ... ]` 内に同じパッケージを列挙

### 3. flake.nix に登録

`perSystem` と overlay の両方に追加する:

```nix
# perSystem
packages.<pname> = pkgs.callPackage ./nix/packages/<pname> { };

# overlay (overlays-configuration の local packages)
<pname> = final.callPackage ./nix/packages/<pname> { };
```

### 4. git add で Nix に認識させる

flake モードでは Git にトラッキングされていないファイルは参照できない。
`init-script.sh` は自動で `git add` するが、flake.nix の変更も追加する:

```bash
git add nix/packages/<pname> flake.nix
```

### 5. ハッシュを取得

```bash
nix build .#<pname> 2>&1 | grep "got:"
```

出力の `got: sha256-...` を `default.nix` の `src.hash` (`lib.fakeHash`) と置き換える。

### 6. オプション調整

必要に応じて以下を追加・変更する。

#### 複数スクリプトを含む場合

```nix
installPhase = ''
  runHook preInstall
  install -Dm755 script-a $out/bin/script-a
  install -Dm755 script-b $out/bin/script-b
  wrapProgram $out/bin/script-a \
    --prefix PATH : ${lib.makeBinPath [ jq curl ]}
  wrapProgram $out/bin/script-b \
    --prefix PATH : ${lib.makeBinPath [ git ]}
  runHook postInstall
'';
```

#### シェル補完を追加する場合

```nix
nativeBuildInputs = [ makeWrapper installShellFiles ];

installPhase = ''
  runHook preInstall
  install -Dm755 <script-name> $out/bin/<script-name>
  wrapProgram $out/bin/<script-name> \
    --prefix PATH : ${lib.makeBinPath [ /* deps */ ]}
  installShellCompletion --bash completions/<pname>.bash
  installShellCompletion --zsh  completions/_<pname>
  installShellCompletion --fish completions/<pname>.fish
  runHook postInstall
'';
```

#### makeWrapper のオプション

| オプション | 用途 | 例 |
|-----------|------|-----|
| `--prefix PATH :` | PATH に追加 | `--prefix PATH : ${lib.makeBinPath [ jq ]}` |
| `--set` | 環境変数を設定 | `--set MY_VAR "value"` |
| `--set-default` | 未設定時のみ設定 | `--set-default EDITOR "vim"` |
| `--suffix PATH :` | PATH の末尾に追加 | `--suffix PATH : ${lib.makeBinPath [ git ]}` |

### 7. nix build でビルド確認

```bash
nix build .#<pname> 2>&1
```

失敗した場合はエラーメッセージに応じてオプション調整を行う。

### 8. home-manager.nix に追加

`nix/home-manager.nix` の適切なリストに追加する:

| カテゴリ | 追加先リスト |
|---------|------------|
| 自作パッケージ | `selfPackages` |
| その他ユーティリティ | `utility` |
| 開発ツール全般 | `devtools` |
| LSP | `lsp` |
| Linter/Formatter | `linter` |

## 完了チェックリスト

- [ ] `nix eval nixpkgs#<pname>.version` で nixpkgs に既存パッケージがないか確認
- [ ] 既存パッケージがある場合、ユーザーにカスタムパッケージが必要か確認（不要なら home-manager.nix への追加のみ）
- [ ] `init-script.sh` でテンプレート生成
- [ ] 依存ツールを `default.nix` に設定
- [ ] `flake.nix` の `perSystem` に追加
- [ ] `flake.nix` の overlay に追加
- [ ] `src.hash` を取得・置換
- [ ] オプション調整（複数スクリプト、シェル補完等）
- [ ] `nix build .#<pname>` が成功する
- [ ] `nix/home-manager.nix` の適切なリストに追加
