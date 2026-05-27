#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

URL_DARWIN="https://dl.google.com/android/cli/latest/darwin_arm64/android"
URL_LINUX="https://dl.google.com/android/cli/latest/linux_x86_64/android"

# Pick a binary that runs on this host so we can read --version.
case "$(uname -s)/$(uname -m)" in
  Darwin/arm64)        URL_VERSION="$URL_DARWIN"; VERSION_MARKER="version-darwin" ;;
  Linux/x86_64)        URL_VERSION="$URL_LINUX"; VERSION_MARKER="version-linux" ;;
  *) echo "unsupported host: $(uname -s)/$(uname -m)" >&2; exit 1 ;;
esac

sed_i() {
  if sed --version >/dev/null 2>&1; then
    sed -i "$@"
  else
    sed -i '' "$@"
  fi
}

TMP_VERSION=$(mktemp)
TMP_DARWIN=$(mktemp)
TMP_LINUX=$(mktemp)
trap 'rm -f "$TMP_VERSION" "$TMP_DARWIN" "$TMP_LINUX"' EXIT

curl -fsSL "$URL_VERSION" -o "$TMP_VERSION"
chmod +x "$TMP_VERSION"
LATEST=$("$TMP_VERSION" --version)

CURRENT_VERSION=$(sed -n "s|.*version = \"\\(.*\\)\"; # $VERSION_MARKER|\\1|p" default.nix | head -1)
CURRENT_HASH_DARWIN=$(sed -n 's|.*hash = "\(.*\)"; # hash-darwin|\1|p' default.nix | head -1)
CURRENT_HASH_LINUX=$(sed -n 's|.*hash = "\(.*\)"; # hash-linux|\1|p' default.nix | head -1)

curl -fsSL "$URL_DARWIN" -o "$TMP_DARWIN"
curl -fsSL "$URL_LINUX" -o "$TMP_LINUX"
HASH_DARWIN=$(nix hash file --sri "$TMP_DARWIN")
HASH_LINUX=$(nix hash file --sri "$TMP_LINUX")

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

sed_i "s|version = \".*\"; # $VERSION_MARKER|version = \"$LATEST\"; # $VERSION_MARKER|" default.nix
sed_i "s|hash = \".*\"; # hash-darwin|hash = \"$HASH_DARWIN\"; # hash-darwin|" default.nix
sed_i "s|hash = \".*\"; # hash-linux|hash = \"$HASH_LINUX\"; # hash-linux|" default.nix
