#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PKG="@github/copilot-language-server"
LATEST=$(npm view "$PKG" version)
CURRENT=$(jq -r '.version' package.json)
[ "$LATEST" = "$CURRENT" ] && echo "$PKG is up to date ($CURRENT)" && exit 0

echo "Updating $PKG: $CURRENT -> $LATEST"
jq --arg v "$LATEST" '.version = $v | .dependencies["@github/copilot-language-server"] = $v' package.json > package.json.tmp
mv package.json.tmp package.json
npm install --package-lock-only
NEW_HASH=$(nix run nixpkgs#prefetch-npm-deps -- package-lock.json 2>/dev/null)
sed -i'' "s/version = \".*\"/version = \"$LATEST\"/" default.nix
sed -i'' "s|npmDepsHash = \".*\"|npmDepsHash = \"$NEW_HASH\"|" default.nix
