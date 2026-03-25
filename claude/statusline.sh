#!/bin/bash
# ccusageのstatusline出力にVCS情報を追加するラッパー

input=$(cat)

# デバッグ: 入力を一時保存（STATUSLINE_DEBUG=1 で有効）
if [ "${STATUSLINE_DEBUG:-0}" = "1" ]; then
    echo "$input" > /tmp/statusline-input.txt
fi

# VCS情報を取得（jj優先、fallbackでgit）
vcs_info="[empty]"
if jj root > /dev/null 2>&1; then
    # jj管理下: workspace名 + 最新2件のタイムスタンプとdescriptionを表示
    change_id=$(jj log -r '@' --no-graph -T 'change_id.shortest(8)' 2>/dev/null)
    workspace_name=$(jj workspace list 2>/dev/null | grep "$change_id" | cut -d: -f1)
    workspace_name="${workspace_name:-unknown}"
    vcs_log=$(jj log -r '::@' --no-graph -T 'if(description.first_line(), description.first_line(), "(no description set)") ++ "\n"' --limit 2 2>/dev/null | sed '/^$/d')
    vcs_info="[${workspace_name}]\n${vcs_log}"
elif git rev-parse --git-dir > /dev/null 2>&1; then
    # git管理下: branch | description
    branch=$(git branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        vcs_info="$branch"
        desc=$(git config branch."$branch".description 2>/dev/null | head -1)
        if [ -n "$desc" ]; then
            vcs_info="$branch | $desc"
        fi
    fi
fi

ccusage=$(echo "$input" | bun x ccusage statusline 2>/dev/null)

echo -e "\033[36m${vcs_info}\033[0m"
echo "$ccusage"
