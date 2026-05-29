## シェルスクリプト向けワークフロー

### テンプレートを一括生成

`init-script.sh` がリリース情報取得・ファイル生成を一括で行う。
リリースタグの有無を自動判定し、適切なテンプレートを生成する。

```bash
bash .claude/skills/create-nix-package/scripts/init-script.sh <pname> <owner> <repo> [script-name]
```

- `script-name` を省略すると `pname` がスクリプト名として使われる
- **タグあり**: `version` はリリースタグから取得、`src.rev` は `tag = "v${version}"`
- **タグなし**: `version = "unstable-YYYY-MM-DD"`、`src.rev` は最新コミットハッシュ

### 依存ツールを設定

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

### ハッシュを取得

```bash
nix build .#<pname> 2>&1 | grep "got:"
```

出力の `got: sha256-...` を `default.nix` の `src.hash` (`lib.fakeHash`) と置き換える。

### オプション調整

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

### 完了チェックリスト

- [ ] `init-script.sh` でテンプレート生成
- [ ] 依存ツールを `default.nix` に設定
- [ ] `src.hash` を取得・置換
- [ ] オプション調整（複数スクリプト、シェル補完等）
- [ ] `nix build .#<pname>` が成功する
