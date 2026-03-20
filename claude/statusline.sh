#!/bin/bash
# ccusageのstatusline出力にVCS情報を追加するラッパー

input=$(cat)

# VCS情報を取得（jj優先、fallbackでgit）
vcs_info="[empty]"
if jj root > /dev/null 2>&1; then
    # jj管理下: bookmark | description
    bookmark=$(jj log -r @ --no-graph -T 'bookmarks.join(", ")' 2>/dev/null)
    desc=$(jj log -r @ --no-graph -T 'description.first_line()' 2>/dev/null)
    if [ -n "$bookmark" ] && [ -n "$desc" ]; then
        vcs_info="$bookmark | $desc"
    elif [ -n "$bookmark" ]; then
        vcs_info="$bookmark"
    elif [ -n "$desc" ]; then
        vcs_info="(no bookmark) | $desc"
    fi
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

echo -e "\033[36m${vcs_info}\033[0m\n$ccusage"
