---
name: context
description: セッションコンテキストを表示。タブを離れて戻ってきた時に「何をやっていたか」「何を依頼したか」「次に何をすべきか」を思い出すために使用。
---

このスキルは、現在のプロジェクトのセッションコンテキストファイルを読み込んで表示します。

## 手順

1. 現在のプロジェクト名とブランチ名からコンテキストファイルのパスを特定
2. `/tmp/claude-contexts/{プロジェクト名}_{ブランチ名}.md` を読み込む
3. 内容をユーザーに表示し、状況を要約する

## 実行

以下のコマンドでコンテキストファイルのパスを取得してください:

```bash
PROJECT_NAME=$(basename "$PWD")
BRANCH_NAME=$(git branch --show-current 2>/dev/null | tr '/' '_')
if [[ -n "$BRANCH_NAME" ]]; then
    echo "/tmp/claude-contexts/${PROJECT_NAME}_${BRANCH_NAME}.md"
else
    echo "/tmp/claude-contexts/${PROJECT_NAME}.md"
fi
```

取得したパスのファイルを Read ツールで読み込み、以下の形式で要約してください:

## 出力フォーマット

```
## 現在のコンテキスト

**プロジェクト**: {プロジェクト名}
**ブランチ**: {ブランチ名}

### 最後の依頼
{最後のユーザープロンプト}

### Claudeの最後の回答
{最後のClaudeの回答}

### Todo状況
{最新のTodoリスト}

### 次にすべきこと
{Todoや会話の流れから推測される次のアクション}
```

ファイルが存在しない場合は「まだコンテキストが記録されていません」と伝えてください。
