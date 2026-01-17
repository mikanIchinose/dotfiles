---
name: codex-review
description: Codex CLIでレビュー・分析をする。trigger: 「codexにレビューして」「レビューして」「review my changes」
allowed-tools: Bash
---

Codex CLIでレビュー・分析をする。

## 実行コマンド

```bash
codex exec --full-auto --sandbox read-only --cd <project_directory> "<request>"
```

## 使用例

### コードレビュー
codex exec --full-auto --sandbox read-only --cd /path/to/project "このプロジェクトのコードをレビューして、改善点を指摘してください"

### バグ調査
codex exec --full-auto --sandbox read-only --cd /path/to/project "認証処理でエラーが発生する原因を調査してください"

## 手順

1. ユーザーから依頼内容を受け取る
2. 依頼内容をCodex用に清書する
3. 対象プロジェクトのディレクトリを特定する
4. 上記コマンド形式でCodexを実行
5. 結果をユーザーに報告

## Rules

- ユーザーの依頼内容は曖昧である可能性が高いです
- AskUserQuestionツールを用いて依頼内容を明らかにする
- Codexのレビューは時間がかかるため、Bashツール実行時に `run_in_background: true` でバックグラウンド実行すること
- バックグラウンド実行後、タスク完了通知を待ってからReadツールで出力ファイルを読み取り、結果を報告すること

