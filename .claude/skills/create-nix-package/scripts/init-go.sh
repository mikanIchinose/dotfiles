#!/usr/bin/env bash
# Go ソースビルド向け Nix パッケージを初期化する。
# GitHub リリース情報を取得して nix/packages/<pname>/{default.nix,update.sh} を生成する。
# ハッシュは lib.fakeHash で仮入力し、flake.nix 登録後に 2段階で取得する。
#
# 使い方: init-go.sh <pname> <owner> <repo>
set -euo pipefail

if [ $# -lt 3 ]; then
  echo "Usage: $0 <pname> <owner> <repo>" >&2
  exit 1
fi
PNAME="$1"
OWNER="$2"
REPO="$3"

SCRIPTS_DIR="$(dirname "$0")"
REPO_ROOT="$(git -C "$SCRIPTS_DIR" rev-parse --show-toplevel)"
PKG_DIR="$REPO_ROOT/nix/packages/$PNAME"

# shellcheck source=lib.sh
source "$SCRIPTS_DIR/lib.sh"

# ---- リリース情報を取得 ----

echo "Fetching release info for $OWNER/$REPO..." >&2
RELEASE=$(gh release view --repo "$OWNER/$REPO" --json tagName)
TAG=$(echo "$RELEASE" | jq -r '.tagName')
VERSION="${TAG#v}"

echo "  version: $VERSION" >&2

# ---- メタデータを取得 ----

REPO_INFO=$(gh api "repos/$OWNER/$REPO" 2>/dev/null || echo '{}')
DESCRIPTION=$(echo "$REPO_INFO" | jq -r '.description // "TODO: add description"')
SPDX=$(echo "$REPO_INFO" | jq -r '.license.spdx_id // "unknown"')
NIX_LICENSE=$(spdx_to_nix "$SPDX")

# ---- ファイルを生成 ----

mkdir -p "$PKG_DIR"

cat > "$PKG_DIR/default.nix" << EOF
{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "$PNAME";
  version = "$VERSION";

  src = fetchFromGitHub {
    owner = "$OWNER";
    repo = "$REPO";
    tag = "v\${version}";
    hash = lib.fakeHash;
  };

  vendorHash = lib.fakeHash;

  meta = with lib; {
    description = "$DESCRIPTION";
    homepage = "https://github.com/$OWNER/$REPO";
    license = $NIX_LICENSE;
    mainProgram = "$PNAME";
  };
}
EOF

cat > "$PKG_DIR/update.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
pkg="$(basename "$(pwd)")"
nix run nixpkgs#nix-update -- --flake --override-filename "nix/packages/$pkg/default.nix" "$pkg"
EOF

chmod +x "$PKG_DIR/update.sh"

git -C "$REPO_ROOT" add "$PKG_DIR"

echo "Generated: $PKG_DIR/{default.nix,update.sh}" >&2
echo "Next steps:" >&2
echo "  1. Add to flake.nix (perSystem + overlay)" >&2
echo "  2. nix build .#$PNAME 2>&1 | grep 'got:' → replace src.hash" >&2
echo "  3. nix build .#$PNAME 2>&1 | grep 'got:' → replace vendorHash" >&2
echo "  4. nix build .#$PNAME → confirm build succeeds" >&2
