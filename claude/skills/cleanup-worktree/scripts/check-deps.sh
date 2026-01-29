#!/bin/bash
# check-deps.sh - 依存ツールの存在確認

set -euo pipefail

missing=()

for cmd in gwq jq git; do
    if ! command -v "$cmd" &>/dev/null; then
        missing+=("$cmd")
    fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
    missing_json=$(printf '%s\n' "${missing[@]}" | jq -R -s 'split("\n") | map(select(length > 0))' 2>/dev/null || echo "[\"${missing[*]}\"]")
    echo "{\"ok\":false,\"missing\":$missing_json}"
    exit 1
fi

echo '{"ok":true,"missing":[]}'
