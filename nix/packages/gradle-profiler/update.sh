#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

LATEST=$(gh release view --repo gradle/gradle-profiler --json tagName -q '.tagName | ltrimstr("v")')
CURRENT=$(sed -n 's/.*version = "\(.*\)".*/\1/p' default.nix | head -1)
[ "$LATEST" = "$CURRENT" ] && echo "gradle-profiler is up to date ($CURRENT)" && exit 0

echo "Updating gradle-profiler: $CURRENT -> $LATEST"

URL="https://repo1.maven.org/maven2/org/gradle/profiler/gradle-profiler/${LATEST}/gradle-profiler-${LATEST}.zip"
HASH=$(nix store prefetch-file --json "$URL" | jq -r '.hash')

sed -i'' "s/version = \".*\"/version = \"$LATEST\"/" default.nix
sed -i'' "s|hash = \".*\"|hash = \"$HASH\"|" default.nix
