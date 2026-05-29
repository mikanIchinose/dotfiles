#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PNAME="flutterfire-cli"
OWNER="invertase"
REPO="flutterfire_cli"
SUBDIR="packages/flutterfire_cli"

# 最新バージョンを取得
TAG=$(gh api "repos/$OWNER/$REPO/git/refs/tags" --paginate --jq '.[].ref' | grep 'flutterfire_cli-v' | sort -V | tail -1 | sed 's|refs/tags/||')
LATEST="${TAG#flutterfire_cli-v}"
CURRENT=$(grep 'version = ' default.nix | head -1 | sed 's/.*"\(.*\)".*/\1/')
[ "$LATEST" = "$CURRENT" ] && echo "$PNAME is up to date ($CURRENT)" && exit 0

echo "Updating $PNAME: $CURRENT -> $LATEST"

# ソースを取得して pubspec.lock.json を再生成
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT
git clone --depth 1 --branch "$TAG" "https://github.com/$OWNER/$REPO.git" "$TMPDIR/src" 2>&1 | tail -1
PUBSPEC_DIR="$TMPDIR/src/$SUBDIR"

if [ ! -f "$PUBSPEC_DIR/pubspec.lock" ]; then
  (cd "$PUBSPEC_DIR" && nix run nixpkgs#dart -- pub get)
fi

nix run nixpkgs#yq-go -- eval --output-format=json --prettyPrint "$PUBSPEC_DIR/pubspec.lock" > pubspec.lock.json

# src hash を取得
URL="https://github.com/$OWNER/$REPO/archive/refs/tags/$TAG.tar.gz"
HASH=$(nix store prefetch-file --json --unpack "$URL" | jq -r '.hash')

# default.nix のバージョンと hash を更新
sed -i'' "s/version = \".*\"/version = \"$LATEST\"/" default.nix
sed -i'' "s|hash = \"sha256-[^\"]*\"|hash = \"$HASH\"|" default.nix

echo "Updated to $LATEST"
