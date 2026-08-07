#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

LATEST=$(gh release view --repo takahirom/cochange --json tagName -q '.tagName | ltrimstr("v")')
CURRENT=$(sed -n 's/.*version = "\(.*\)".*/\1/p' default.nix | head -1)
[ "$LATEST" = "$CURRENT" ] && echo "cochange is up to date ($CURRENT)" && exit 0

echo "Updating cochange: $CURRENT -> $LATEST"

URL="https://github.com/takahirom/cochange/releases/download/${LATEST}/cochange-${LATEST}.tar.gz"
HASH=$(nix store prefetch-file --json "$URL" | jq -r '.hash')

sed -i'' "s/version = \".*\"/version = \"$LATEST\"/" default.nix
sed -i'' "s|hash = \".*\"|hash = \"$HASH\"|" default.nix
