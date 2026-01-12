#!/bin/bash
# PostToolCall hook (TodoWrite): Todoリストをセッションコンテキストに保存
# 保存先: /tmp/claude-contexts/{プロジェクト名}_{ブランチ名}.md
#
# Input Schema (stdin JSON):
# {
#   "session_id": "string",
#   "transcript_path": "string",
#   "cwd": "string",
#   "permission_mode": "string",
#   "hook_event_name": "PostToolCall",
#   "tool_name": "TodoWrite",
#   "tool_input": {
#     "todos": [
#       { "content": "string", "status": "pending|in_progress|completed", "activeForm": "string" }
#     ]
#   },
#   "tool_response": "string"
# }
#
# Environment Variables:
#   CLAUDE_PROJECT_DIR - プロジェクトルートへの絶対パス

set -e

# stdin から JSON を読み込み
INPUT=$(cat)

# JSON から値を抽出
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# TodoWrite以外は終了
if [[ "$TOOL_NAME" != "TodoWrite" ]]; then
    exit 0
fi

# プロジェクトディレクトリが設定されていなければ終了
if [[ -z "$CLAUDE_PROJECT_DIR" ]]; then
    exit 0
fi

# Todoリストを取得
TODOS=$(echo "$INPUT" | jq -r '.tool_input.todos // []')

# Todoがなければ終了
if [[ "$TODOS" == "[]" || "$TODOS" == "null" ]]; then
    exit 0
fi

# プロジェクト名を取得（ディレクトリ名）
PROJECT_NAME=$(basename "$CLAUDE_PROJECT_DIR")

# ブランチ名を取得（gitリポジトリの場合）
BRANCH_NAME=""
if git -C "$CLAUDE_PROJECT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH_NAME=$(git -C "$CLAUDE_PROJECT_DIR" branch --show-current 2>/dev/null || echo "")
fi

# ファイル名を構築
if [[ -n "$BRANCH_NAME" ]]; then
    # ブランチ名の / を _ に置換
    SAFE_BRANCH=$(echo "$BRANCH_NAME" | tr '/' '_')
    FILENAME="${PROJECT_NAME}_${SAFE_BRANCH}.md"
else
    FILENAME="${PROJECT_NAME}.md"
fi

# 保存先ディレクトリを作成
CONTEXT_DIR="/tmp/claude-contexts"
mkdir -p "$CONTEXT_DIR"

CONTEXT_FILE="$CONTEXT_DIR/$FILENAME"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Todoリストをマークダウン形式に変換
TODO_MD=$(echo "$TODOS" | jq -r '
    .[] |
    if .status == "completed" then "- [x] " + .content
    elif .status == "in_progress" then "- [>] " + .content + " (進行中)"
    else "- [ ] " + .content
    end
')

# ファイルが存在しない場合はヘッダーを作成
if [[ ! -f "$CONTEXT_FILE" ]]; then
    cat > "$CONTEXT_FILE" << EOF
# Session Context: $PROJECT_NAME

**ブランチ**: $BRANCH_NAME
**パス**: $CLAUDE_PROJECT_DIR

このファイルはClaude Codeのhookによって自動生成されます。
タブを離れて戻ってきた時に、何をやっていたか思い出すために使います。

---

EOF
fi

# Todoを記録
cat >> "$CONTEXT_FILE" << EOF
## [$TIMESTAMP] Todo更新

$TODO_MD

EOF

exit 0
