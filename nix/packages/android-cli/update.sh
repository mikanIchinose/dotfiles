#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

URL_DARWIN="https://edgedl.me.gvt1.com/edgedl/android/cli/latest/darwin_arm64/android"
URL_LINUX="https://edgedl.me.gvt1.com/edgedl/android/cli/latest/linux_x86_64/android"

# Pick a binary that runs on this host so we can read --version.
case "$(uname -s)/$(uname -m)" in
  Darwin/arm64)        URL_VERSION="$URL_DARWIN" ;;
  Linux/x86_64)        URL_VERSION="$URL_LINUX" ;;
  *) echo "unsupported host: $(uname -s)/$(uname -m)" >&2; exit 1 ;;
esac

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT
curl -fsSL "$URL_VERSION" -o "$TMP"
chmod +x "$TMP"
LATEST=$("$TMP" --version)

CURRENT_VERSION=$(sed -n 's/.*version = "\(.*\)".*/\1/p' default.nix | head -1)
CURRENT_HASH_DARWIN=$(sed -n 's|.*hash = "\(.*\)"; # hash-darwin|\1|p' default.nix | head -1)
CURRENT_HASH_LINUX=$(sed -n 's|.*hash = "\(.*\)"; # hash-linux|\1|p' default.nix | head -1)

HASH_DARWIN=$(nix store prefetch-file --json "$URL_DARWIN" | jq -r '.hash')
HASH_LINUX=$(nix store prefetch-file --json "$URL_LINUX" | jq -r '.hash')

if [ "$LATEST" = "$CURRENT_VERSION" ] \
  && [ "$HASH_DARWIN" = "$CURRENT_HASH_DARWIN" ] \
  && [ "$HASH_LINUX" = "$CURRENT_HASH_LINUX" ]; then
  echo "android-cli is up to date ($CURRENT_VERSION)"
  exit 0
fi

if [ "$LATEST" = "$CURRENT_VERSION" ]; then
  echo "Refreshing android-cli hashes (version unchanged: $CURRENT_VERSION)"
else
  echo "Updating android-cli: $CURRENT_VERSION -> $LATEST"
fi

sed -i'' "s/version = \".*\"/version = \"$LATEST\"/" default.nix
sed -i'' "s|hash = \".*\"; # hash-darwin|hash = \"$HASH_DARWIN\"; # hash-darwin|" default.nix
sed -i'' "s|hash = \".*\"; # hash-linux|hash = \"$HASH_LINUX\"; # hash-linux|" default.nix
