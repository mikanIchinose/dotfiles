#!/bin/bash
# gone-branches.sh - リモートで削除済み(gone)のブランチをJSON形式で出力

set -euo pipefail

# Fetch and prune first
git fetch --prune origin 2>/dev/null || true

# Get gone branches
gone_branches=$(git branch -vv 2>/dev/null | grep ': gone]' | awk '{print $1}' | sed 's/^\*//' | tr -d ' ')

if [[ -z "$gone_branches" ]]; then
    echo '{"count":0,"branches":[]}'
    exit 0
fi

# Convert to JSON array
branches_json=$(echo "$gone_branches" | jq -R -s 'split("\n") | map(select(length > 0))')
count=$(echo "$branches_json" | jq 'length')

cat <<EOF
{
  "count": $count,
  "branches": $branches_json
}
EOF
