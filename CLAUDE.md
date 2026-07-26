## dotfiles Structure

- **Nix** で環境管理（nix-darwin + home-manager）
- **config/** 配下のツール設定を `~/.config` へ symlink
- **claude/** 配下は `~/.claude` へ home-manager でデプロイ（Claude Code グローバル設定の実体）
- カスタムパッケージは `nix/packages/` で管理

## Rules

- パターンを一括修正する際は、対象ファイルだけでなく Grep でリポジトリ全体（`.claude/skills/` 配下のスクリプト・テンプレート含む）を検索し、全出現箇所を特定してから修正する

### スキル・エージェントを書くときのルール

- **思考過程を応答本文に書かせる指示を入れない** — 「考えた過程を説明して」「判断理由を
  出力して」のような指示は Fable で `reasoning_extraction` リフューザルを誘発し、
  Opus へのフォールバックが増える。推論を可視化したい場合は、思考そのものではなく
  結論の根拠（参照した file:line、コマンド出力）を書かせる
- サブエージェントに書き込み権限を渡すのは、そのエージェントの成果物に必要な範囲まで。
  レビュー系エージェントのように「指摘だけ出す」役割には編集系ツールを与えない

## Version control
### message format

```
<scope>: <description>

[optional body]

[optional footer]
```

#### scope（必須）
- 変更対象のツール名をそのまま使用
- 例: `nix`, `fish`, `nvim`, `git`, `ghostty`, `ghq`, `gh`, `claude`, etc.
- 特殊スコープ:
  - `ci` - GitHub Actions など CI 関連
  - `docs` - README, ドキュメント
  - `chore` - リポジトリ全体・分類不能なもの
- 複数スコープにまたがる場合はコミットを分ける

#### description（必須）
- 小文字の動詞で始める（命令形）
- 主な動詞: `add`, `remove`, `update`, `fix`, `refactor`, `migrate`
- 末尾にピリオドを付けない

#### body / footer（任意）
- 1行空けて記述
- 破壊的変更: `BREAKING CHANGE: 説明`

#### 例

```
ghostty: add keybinding for split pane
```

```
gh: update aliases
```

```
nix: update flake.lock
```
