#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

LATEST=$(gh release view --repo high-moctane/mocword --json tagName -q '.tagName | ltrimstr("v")')
CURRENT=$(sed -n 's/.*version = "\(.*\)".*/\1/p' default.nix)
[ "$LATEST" = "$CURRENT" ] && echo "mocword is up to date ($CURRENT)" && exit 0

echo "Updating mocword: $CURRENT -> $LATEST"
URL="https://github.com/high-moctane/mocword/releases/download/v${LATEST}/mocword-aarch64-apple-darwin"
HASH=$(nix store prefetch-file --json "$URL" | jq -r '.hash')
sed -i '' "s/version = \".*\"/version = \"$LATEST\"/" default.nix
sed -i '' "s|hash = \".*\"|hash = \"$HASH\"|" default.nix
