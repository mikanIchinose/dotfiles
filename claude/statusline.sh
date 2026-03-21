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
    # jj管理下: 最新2件のタイムスタンプとdescriptionを表示
    vcs_info=$(jj log -r '::@' --no-graph -T 'committer.timestamp().format("%Y-%m-%d %H:%M:%S") ++ " " ++ if(description.first_line(), description.first_line(), "(no description set)") ++ "\n"' --limit 2 2>/dev/null | sed '/^$/d')
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
