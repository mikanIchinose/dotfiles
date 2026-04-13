#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

URL_DARWIN="https://edgedl.me.gvt1.com/edgedl/android/cli/latest/darwin_arm64/android"
URL_LINUX="https://edgedl.me.gvt1.com/edgedl/android/cli/latest/linux_x86_64/android"

TMP_DARWIN=$(mktemp)
trap 'rm -f "$TMP_DARWIN"' EXIT
curl -fsSL "$URL_DARWIN" -o "$TMP_DARWIN"
chmod +x "$TMP_DARWIN"
LATEST=$("$TMP_DARWIN" --version)
CURRENT=$(sed -n 's/.*version = "\(.*\)".*/\1/p' default.nix | head -1)
[ "$LATEST" = "$CURRENT" ] && echo "android-cli is up to date ($CURRENT)" && exit 0

echo "Updating android-cli: $CURRENT -> $LATEST"

HASH_DARWIN=$(nix store prefetch-file --json "$URL_DARWIN" | jq -r '.hash')
HASH_LINUX=$(nix store prefetch-file --json "$URL_LINUX" | jq -r '.hash')

sed -i'' "s/version = \".*\"/version = \"$LATEST\"/" default.nix
sed -i'' "s|hash = \".*\"; # hash-darwin|hash = \"$HASH_DARWIN\"; # hash-darwin|" default.nix
sed -i'' "s|hash = \".*\"; # hash-linux|hash = \"$HASH_LINUX\"; # hash-linux|" default.nix
