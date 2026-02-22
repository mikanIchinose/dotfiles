#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

LATEST=$(gh release view --repo flxo/rogcat --json tagName -q '.tagName | ltrimstr("v")')
CURRENT=$(sed -n 's/.*version = "\(.*\)".*/\1/p' default.nix)
[ "$LATEST" = "$CURRENT" ] && echo "rogcat is up to date ($CURRENT)" && exit 0

echo "Updating rogcat: $CURRENT -> $LATEST"
HASH=$(nix store prefetch-file --json "https://github.com/flxo/rogcat/releases/download/v${LATEST}/rogcat-aarch64-apple-darwin.tar.xz" | jq -r '.hash')
sed -i'' "s/version = \".*\"/version = \"$LATEST\"/" default.nix
sed -i'' "s|hash = \".*\"|hash = \"$HASH\"|" default.nix
