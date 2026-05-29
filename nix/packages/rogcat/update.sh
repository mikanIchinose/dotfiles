#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

LATEST=$(gh release view --repo flxo/rogcat --json tagName -q '.tagName | ltrimstr("v")')
CURRENT=$(sed -n 's/.*version = "\(.*\)".*/\1/p' default.nix | head -1)
[ "$LATEST" = "$CURRENT" ] && echo "rogcat is up to date ($CURRENT)" && exit 0

echo "Updating rogcat: $CURRENT -> $LATEST"

# aarch64-darwin
URL_DARWIN="https://github.com/flxo/rogcat/releases/download/v${LATEST}/rogcat-aarch64-apple-darwin.tar.xz"
HASH_DARWIN=$(nix store prefetch-file --json "$URL_DARWIN" | jq -r '.hash')

# x86_64-linux
URL_LINUX="https://github.com/flxo/rogcat/releases/download/v${LATEST}/rogcat-x86_64-unknown-linux-gnu.tar.xz"
HASH_LINUX=$(nix store prefetch-file --json "$URL_LINUX" | jq -r '.hash')

sed -i'' "s/version = \".*\"/version = \"$LATEST\"/" default.nix
sed -i'' "s|hash = \".*\"; # hash-darwin|hash = \"$HASH_DARWIN\"; # hash-darwin|" default.nix
sed -i'' "s|hash = \".*\"; # hash-linux|hash = \"$HASH_LINUX\"; # hash-linux|" default.nix
