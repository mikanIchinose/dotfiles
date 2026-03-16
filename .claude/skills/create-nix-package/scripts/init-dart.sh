#!/usr/bin/env bash
# Dart パッケージ向け Nix パッケージを初期化する。
# GitHub リリース情報を取得して nix/packages/<pname>/{default.nix,pubspec.lock.json,update.sh} を生成する。
# ハッシュは lib.fakeHash で仮入力し、flake.nix 登録後に取得する。
#
# 使い方: init-dart.sh <pname> <owner> <repo> [subdir]
#   subdir: モノレポの場合のサブディレクトリ（例: packages/flutterfire_cli）
set -euo pipefail

if [ $# -lt 3 ]; then
  echo "Usage: $0 <pname> <owner> <repo> [subdir]" >&2
  exit 1
fi
PNAME="$1"
OWNER="$2"
REPO="$3"
SUBDIR="${4:-}"

SCRIPTS_DIR="$(dirname "$0")"
REPO_ROOT="$(git -C "$SCRIPTS_DIR" rev-parse --show-toplevel)"
PKG_DIR="$REPO_ROOT/nix/packages/$PNAME"

# shellcheck source=lib.sh
source "$SCRIPTS_DIR/lib.sh"

# ---- リリース情報を取得 ----

echo "Fetching release info for $OWNER/$REPO..." >&2

# gh release view → 失敗時はタグ一覧からフォールバック
if RELEASE=$(gh release view --repo "$OWNER/$REPO" --json tagName 2>/dev/null); then
  TAG=$(echo "$RELEASE" | jq -r '.tagName')
else
  echo "  No GitHub release found, falling back to tags..." >&2
  # パッケージ名ベースのプレフィックス付きタグを優先検索（モノレポ対応）
  # 例: flutterfire_cli-v1.3.1, melos-v6.0.0
  REPO_NAME=$(basename "$REPO" | tr '-' '_')
  TAG=$(gh api "repos/$OWNER/$REPO/git/refs/tags" --paginate --jq '.[].ref | sub("^refs/tags/"; "")' \
    | grep -E "^${REPO_NAME}-v[0-9]" \
    | sort -V | tail -1 || true)
  # プレフィックスなしタグにフォールバック（v1.0.0 形式）
  if [ -z "$TAG" ]; then
    TAG=$(gh api "repos/$OWNER/$REPO/git/refs/tags" --paginate --jq '.[].ref | sub("^refs/tags/"; "")' \
      | grep -E '^v?[0-9]+\.[0-9]+' | grep -v '-' \
      | sort -V | tail -1 || true)
  fi
  if [ -z "$TAG" ]; then
    echo "Error: Could not determine latest tag for $OWNER/$REPO" >&2
    exit 1
  fi
fi

# タグからバージョンを抽出（プレフィックスを除去）
# 例: flutterfire_cli-v1.3.1 → 1.3.1, v1.0.0 → 1.0.0
VERSION=$(echo "$TAG" | sed 's/.*-v//' | sed 's/^v//')

echo "  tag: $TAG" >&2
echo "  version: $VERSION" >&2

# ---- メタデータを取得 ----

REPO_INFO=$(gh api "repos/$OWNER/$REPO" 2>/dev/null || echo '{}')
DESCRIPTION=$(echo "$REPO_INFO" | jq -r '.description // "TODO: add description"')
SPDX=$(echo "$REPO_INFO" | jq -r '.license.spdx_id // "unknown"')
NIX_LICENSE=$(spdx_to_nix "$SPDX")

echo "  description: $DESCRIPTION" >&2
echo "  license: $SPDX -> $NIX_LICENSE" >&2

# ---- pubspec.lock.json を生成 ----

echo "Cloning source to generate pubspec.lock.json..." >&2
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

git clone --depth 1 --branch "$TAG" "https://github.com/$OWNER/$REPO.git" "$TMPDIR/src" 2>&1 | tail -1 >&2

PUBSPEC_DIR="$TMPDIR/src"
if [ -n "$SUBDIR" ]; then
  PUBSPEC_DIR="$TMPDIR/src/$SUBDIR"
fi

if [ ! -f "$PUBSPEC_DIR/pubspec.lock" ]; then
  echo "Warning: pubspec.lock not found at $PUBSPEC_DIR" >&2
  echo "Running 'dart pub get' to generate it..." >&2
  (cd "$PUBSPEC_DIR" && nix run nixpkgs#dart -- pub get) >&2
fi

if [ ! -f "$PUBSPEC_DIR/pubspec.lock" ]; then
  echo "Error: pubspec.lock still not found. Manual intervention required." >&2
  exit 1
fi

# ---- ファイルを生成 ----

mkdir -p "$PKG_DIR"

# pubspec.lock.json
nix run nixpkgs#yq-go -- eval --output-format=json --prettyPrint "$PUBSPEC_DIR/pubspec.lock" > "$PKG_DIR/pubspec.lock.json"
echo "  Generated pubspec.lock.json" >&2

# Git 依存を検出
GIT_DEPS=$(nix run nixpkgs#yq-go -- eval '.packages | to_entries | map(select(.value.source == "git")) | .[].key' "$PUBSPEC_DIR/pubspec.lock" 2>/dev/null || echo "")
HAS_GIT_DEPS=false
GIT_HASHES_NIX=""
if [ -n "$GIT_DEPS" ]; then
  HAS_GIT_DEPS=true
  echo "  Warning: Git dependencies detected:" >&2
  echo "$GIT_DEPS" | while read -r dep; do
    echo "    - $dep" >&2
  done
  GIT_HASHES_ENTRIES=""
  while IFS= read -r dep; do
    [ -z "$dep" ] && continue
    GIT_HASHES_ENTRIES+="    $dep = lib.fakeHash;\n"
  done <<< "$GIT_DEPS"
  GIT_HASHES_NIX="\n  gitHashes = {\n${GIT_HASHES_ENTRIES}  };\n"
fi

# sourceRoot の設定
SOURCE_ROOT_NIX=""
if [ -n "$SUBDIR" ]; then
  SOURCE_ROOT_NIX="\n  sourceRoot = \"\${src.name}/$SUBDIR\";\n"
fi

# default.nix
cat > "$PKG_DIR/default.nix" << EOF
{
  lib,
  buildDartApplication,
  fetchFromGitHub,
}:

buildDartApplication rec {
  pname = "$PNAME";
  version = "$VERSION";

  src = fetchFromGitHub {
    owner = "$OWNER";
    repo = "$REPO";
    tag = "$TAG";
    hash = lib.fakeHash;
  };
$([ -n "$SOURCE_ROOT_NIX" ] && printf '%b' "$SOURCE_ROOT_NIX" || true)
  pubspecLock = lib.importJSON ./pubspec.lock.json;
$([ "$HAS_GIT_DEPS" = true ] && printf '%b' "$GIT_HASHES_NIX" || true)
  meta = with lib; {
    description = "$DESCRIPTION";
    homepage = "https://github.com/$OWNER/$REPO";
    license = $NIX_LICENSE;
    mainProgram = "$PNAME";
  };
}
EOF

# tag のプレフィックス判定（v 付きかどうか）
TAG_TEMPLATE="v\${version}"
if [ "$TAG" = "$VERSION" ]; then
  TAG_TEMPLATE="\${version}"
fi

# update.sh
cat > "$PKG_DIR/update.sh" << UPDATEEOF
#!/usr/bin/env bash
set -euo pipefail
cd "\$(dirname "\$0")"
PNAME="$PNAME"
OWNER="$OWNER"
REPO="$REPO"
SUBDIR="$SUBDIR"

# 最新バージョンを取得（release → タグ一覧フォールバック）
TAG=\$(gh release view --repo "\$OWNER/\$REPO" --json tagName -q '.tagName' 2>/dev/null || true)
if [ -z "\$TAG" ]; then
  REPO_NAME=\$(basename "\$REPO" | tr '-' '_')
  TAG=\$(gh api "repos/\$OWNER/\$REPO/git/refs/tags" --paginate --jq '.[].ref | sub("^refs/tags/"; "")' \
    | grep -E "^\${REPO_NAME}-v[0-9]" | sort -V | tail -1 || true)
  [ -z "\$TAG" ] && TAG=\$(gh api "repos/\$OWNER/\$REPO/git/refs/tags" --paginate --jq '.[].ref | sub("^refs/tags/"; "")' \
    | grep -E '^v?[0-9]+\.[0-9]+' | grep -v '-' | sort -V | tail -1)
fi
LATEST=\$(echo "\$TAG" | sed 's/.*-v//' | sed 's/^v//')
CURRENT=\$(grep 'version = ' default.nix | head -1 | sed 's/.*"\(.*\)".*/\1/')
[ "\$LATEST" = "\$CURRENT" ] && echo "\$PNAME is up to date (\$CURRENT)" && exit 0

echo "Updating \$PNAME: \$CURRENT -> \$LATEST"

# ソースを取得して pubspec.lock.json を再生成
TMPDIR=\$(mktemp -d)
trap 'rm -rf "\$TMPDIR"' EXIT
git clone --depth 1 --branch "\$TAG" "https://github.com/\$OWNER/\$REPO.git" "\$TMPDIR/src" 2>&1 | tail -1
PUBSPEC_DIR="\$TMPDIR/src"
[ -n "\$SUBDIR" ] && PUBSPEC_DIR="\$TMPDIR/src/\$SUBDIR"

if [ ! -f "\$PUBSPEC_DIR/pubspec.lock" ]; then
  (cd "\$PUBSPEC_DIR" && nix run nixpkgs#dart -- pub get)
fi

nix run nixpkgs#yq-go -- eval --output-format=json --prettyPrint "\$PUBSPEC_DIR/pubspec.lock" > pubspec.lock.json

# default.nix のバージョンとタグを更新
sed -i'' "s/version = \".*\"/version = \"\$LATEST\"/" default.nix
sed -i'' "s/tag = \".*\"/tag = \"\$TAG\"/" default.nix

echo "Updated to \$LATEST. Run 'nix build' to get new src hash."
UPDATEEOF

chmod +x "$PKG_DIR/update.sh"

git -C "$REPO_ROOT" add "$PKG_DIR"

echo "" >&2
echo "Generated: $PKG_DIR/{default.nix,pubspec.lock.json,update.sh}" >&2
echo "Next steps:" >&2
echo "  1. Add to flake.nix (perSystem + overlay)" >&2
echo "  2. git add nix/packages/$PNAME flake.nix" >&2
echo "  3. nix build .#$PNAME 2>&1 | grep 'got:' -> replace src.hash" >&2
if [ "$HAS_GIT_DEPS" = true ]; then
  echo "  4. nix build .#$PNAME 2>&1 -> get gitHashes (one at a time)" >&2
  echo "  5. nix build .#$PNAME -> confirm build succeeds" >&2
else
  echo "  4. nix build .#$PNAME -> confirm build succeeds" >&2
fi
