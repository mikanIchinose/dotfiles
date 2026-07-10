---
name: codex-review
description: Codex CLIでレビュー・分析をする。「codexにレビューして」「レビューして」「review my changes」と依頼された際に使用
allowed-tools: Bash
---

## 実行コマンド

```bash
codex exec --full-auto --sandbox read-only --cd <project_directory> "<request>"
```

## 使用例

### コードレビュー
```bash
codex exec --full-auto --sandbox read-only --cd /path/to/project "このプロジェクトのコードをレビューして、改善点を指摘してください"
```

### バグ調査
```bash
codex exec --full-auto --sandbox read-only --cd /path/to/project "認証処理でエラーが発生する原因を調査してください"
```

## 手順

1. ユーザーから依頼内容を受け取る
  - ユーザーに質問して依頼内容の意図や詳細を明らかにする
  - ブランチ通しの差分をレビューする場合はベースブランチがどれかを聞く
2. 依頼内容をCodex用に清書する
3. 対象プロジェクトのディレクトリを特定する
4. 上記コマンド形式でCodexを実行
5. 結果をユーザーに報告

## Rules

- ユーザーの依頼内容は曖昧なのでAskUserQuestionツールを用いて依頼内容を明らかにする

