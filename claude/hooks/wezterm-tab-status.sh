#!/bin/bash
# Claude Code hook: WezTermタブタイトルにステータスプレフィックスを設定
#
# Stop → [DONE], Notification → [WAIT], UserPromptSubmit → クリア

set -e

INPUT=$(cat)
EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // empty')

# WEZTERM_PANE が無ければ WezTerm 外なのでスキップ
if [[ -z "$WEZTERM_PANE" ]]; then
    exit 0
fi

case "$EVENT" in
    Stop)
        wezterm cli set-tab-title --pane-id "$WEZTERM_PANE" "🟢" ;;
    Notification)
        wezterm cli set-tab-title --pane-id "$WEZTERM_PANE" "💬" ;;
    UserPromptSubmit)
        wezterm cli set-tab-title --pane-id "$WEZTERM_PANE" "" ;;
esac

exit 0
