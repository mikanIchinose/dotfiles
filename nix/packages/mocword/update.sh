#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

LATEST=$(gh release view --repo high-moctane/mocword --json tagName -q '.tagName | ltrimstr("v")')
CURRENT=$(sed -n 's/.*version = "\(.*\)".*/\1/p' default.nix | head -1)
[ "$LATEST" = "$CURRENT" ] && echo "mocword is up to date ($CURRENT)" && exit 0

echo "Updating mocword: $CURRENT -> $LATEST"

# aarch64-darwin
URL_DARWIN="https://github.com/high-moctane/mocword/releases/download/v${LATEST}/mocword-aarch64-apple-darwin"
HASH_DARWIN=$(nix store prefetch-file --json "$URL_DARWIN" | jq -r '.hash')

# x86_64-linux
URL_LINUX="https://github.com/high-moctane/mocword/releases/download/v${LATEST}/mocword-x86_64-unknown-linux-musl"
HASH_LINUX=$(nix store prefetch-file --json "$URL_LINUX" | jq -r '.hash')

sed -i'' "s/version = \".*\"/version = \"$LATEST\"/" default.nix
sed -i'' "s|hash = \".*\"; # hash-darwin|hash = \"$HASH_DARWIN\"; # hash-darwin|" default.nix
sed -i'' "s|hash = \".*\"; # hash-linux|hash = \"$HASH_LINUX\"; # hash-linux|" default.nix
