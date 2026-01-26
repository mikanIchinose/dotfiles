#!/bin/bash
# ccusageのstatusline出力にgitブランチのdescriptionを追加するラッパー

input=$(cat)

# ccusageのstatusline出力を取得
# ccusage_output=$(echo "$input" | bun x ccusage statusline 2>/dev/null)

# gitブランチ名とdescriptionを取得
git_info=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        git_info="$branch"
        desc=$(git config branch."$branch".description 2>/dev/null | head -1)
        if [ -n "$desc" ]; then
            git_info="$branch | $desc"
        fi
    fi
fi

# 結合して出力
# echo "${ccusage_output} | ${git_info}"
echo -e "\033[36m${git_info}\033[0m"
