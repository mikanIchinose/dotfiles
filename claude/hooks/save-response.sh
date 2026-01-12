#!/bin/bash
# Stop hook: AIの応答をセッションコンテキストに保存
# 保存先: /tmp/claude-contexts/{プロジェクト名}_{ブランチ名}.md
#
# Input Schema (stdin JSON):
# {
#   "session_id": "string - セッションID",
#   "transcript_path": "string - トランスクリプトファイルのパス (JSONL形式)",
#   "cwd": "string - 現在の作業ディレクトリ",
#   "permission_mode": "string - 権限モード",
#   "hook_event_name": "Stop",
#   "stop_hook_active": "boolean - 既にStop hookで継続中か"
# }
#
# Transcript JSONL Entry Schema:
# {
#   "type": "assistant|user",
#   "message": {
#     "content": [
#       { "type": "text", "text": "..." },
#       { "type": "tool_use", "name": "...", "input": {...} },
#       { "type": "thinking", "thinking": "..." }
#     ]
#   },
#   "timestamp": "ISO8601 timestamp",
#   ...
# }
#
# Environment Variables:
#   CLAUDE_PROJECT_DIR - プロジェクトルートへの絶対パス

set -e

# stdin から JSON を読み込み
INPUT=$(cat)

# JSON から値を抽出
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')

# トランスクリプトパスがなければ終了
if [[ -z "$TRANSCRIPT_PATH" || ! -f "$TRANSCRIPT_PATH" ]]; then
    exit 0
fi

# プロジェクトディレクトリが設定されていなければ終了
if [[ -z "$CLAUDE_PROJECT_DIR" ]]; then
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

# トランスクリプトから最後のassistantテキスト応答を取得
# type=="assistant" かつ message.content に type=="text" があるエントリの最後を取得
LAST_RESPONSE=$(tac "$TRANSCRIPT_PATH" | while IFS= read -r line; do
    MSG_TYPE=$(echo "$line" | jq -r '.type // empty')
    if [[ "$MSG_TYPE" == "assistant" ]]; then
        # message.content から type=="text" のテキストを結合
        TEXT=$(echo "$line" | jq -r '
            .message.content // []
            | map(select(.type == "text"))
            | map(.text)
            | join("\n")
        ')
        if [[ -n "$TEXT" && "$TEXT" != "null" ]]; then
            echo "$TEXT"
            break
        fi
    fi
done)

# 応答がなければ終了
if [[ -z "$LAST_RESPONSE" ]]; then
    exit 0
fi

# 応答を最大1000文字に制限（長すぎる場合）
if [[ ${#LAST_RESPONSE} -gt 1000 ]]; then
    LAST_RESPONSE="${LAST_RESPONSE:0:1000}

...(truncated)"
fi

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

# AIの応答を記録
cat >> "$CONTEXT_FILE" << EOF
## [$TIMESTAMP] Claude

$LAST_RESPONSE

EOF

exit 0
