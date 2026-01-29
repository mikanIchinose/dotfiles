#!/bin/bash
# orphan-branches.sh - worktreeに紐づかないローカルブランチをJSON形式で出力

set -euo pipefail

# Get all local branches (exclude current branch marked with *)
all_branches=$(git branch 2>/dev/null | sed 's/^\*//' | tr -d ' ' | grep -v '^$')

# Get branches used by worktrees
worktree_branches=$(git worktree list --porcelain 2>/dev/null | grep '^branch ' | sed 's/^branch refs\/heads\///')

# Find orphan branches (not used by any worktree)
orphan_branches=""
while IFS= read -r branch; do
    if ! echo "$worktree_branches" | grep -qx "$branch"; then
        orphan_branches="$orphan_branches$branch"$'\n'
    fi
done <<< "$all_branches"

# Remove trailing newline and empty lines
orphan_branches=$(echo "$orphan_branches" | grep -v '^$' || true)

if [[ -z "$orphan_branches" ]]; then
    echo '{"count":0,"branches":[]}'
    exit 0
fi

# Convert to JSON array
branches_json=$(echo "$orphan_branches" | jq -R -s 'split("\n") | map(select(length > 0))')
count=$(echo "$branches_json" | jq 'length')

cat <<EOF
{
  "count": $count,
  "branches": $branches_json
}
EOF
