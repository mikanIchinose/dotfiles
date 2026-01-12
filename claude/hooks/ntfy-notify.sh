#!/bin/bash
# Stop hook: ntfy.shにリッチな完了通知を送信

set -e

NTFY_TOPIC="ntfy.sh/mikan-claude-code"

# stdin から JSON を読み込み
INPUT=$(cat)

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# プロジェクト名
PROJECT_NAME=""
if [[ -n "$CWD" ]]; then
    PROJECT_NAME=$(basename "$CWD")
fi

# デフォルトメッセージ
MESSAGE="タスクが完了しました"
TAGS="robot,white_check_mark"

# トランスクリプトから最後のassistant応答を取得
if [[ -n "$TRANSCRIPT_PATH" && -f "$TRANSCRIPT_PATH" ]]; then
    LAST_RESPONSE=$(tac "$TRANSCRIPT_PATH" | while IFS= read -r line; do
        MSG_TYPE=$(echo "$line" | jq -r '.type // empty')
        if [[ "$MSG_TYPE" == "assistant" ]]; then
            TEXT=$(echo "$line" | jq -r '
                .message.content // []
                | map(select(.type == "text"))
                | map(.text)
                | join(" ")
            ' | tr '\n' ' ' | sed 's/  */ /g')
            if [[ -n "$TEXT" && "$TEXT" != "null" ]]; then
                echo "$TEXT"
                break
            fi
        fi
    done)

    # 30字以内に制限
    if [[ -n "$LAST_RESPONSE" ]]; then
        if [[ ${#LAST_RESPONSE} -gt 30 ]]; then
            MESSAGE="${LAST_RESPONSE:0:30}..."
        else
            MESSAGE="$LAST_RESPONSE"
        fi
    fi
fi

# タイトル
if [[ -n "$PROJECT_NAME" ]]; then
    TITLE="Claude Code - $PROJECT_NAME"
else
    TITLE="Claude Code"
fi

# ntfy.shに送信
curl -s \
    -H "Title: $TITLE" \
    -H "Tags: $TAGS" \
    -H "Priority: default" \
    -d "$MESSAGE" \
    "$NTFY_TOPIC" > /dev/null 2>&1

exit 0
