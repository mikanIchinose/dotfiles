#!/usr/bin/env bash
# シェルスクリプト向け Nix パッケージを初期化する。
# GitHub リリースタグの有無を自動判定し、nix/packages/<pname>/{default.nix,update.sh} を生成する。
# ハッシュは lib.fakeHash で仮入力し、flake.nix 登録後に取得する。
#
# 使い方: init-script.sh <pname> <owner> <repo> [script-name]
#   script-name を省略すると pname がスクリプト名として使われる。
set -euo pipefail

if [ $# -lt 3 ]; then
  echo "Usage: $0 <pname> <owner> <repo> [script-name]" >&2
  exit 1
fi
PNAME="$1"
OWNER="$2"
REPO="$3"
SCRIPT_NAME="${4:-$PNAME}"

SCRIPTS_DIR="$(dirname "$0")"
REPO_ROOT="$(git -C "$SCRIPTS_DIR" rev-parse --show-toplevel)"
PKG_DIR="$REPO_ROOT/nix/packages/$PNAME"

# shellcheck source=lib.sh
source "$SCRIPTS_DIR/lib.sh"

# ---- リリースタグの有無を判定 ----

HAS_TAG=true
if ! gh release view --repo "$OWNER/$REPO" --json tagName > /dev/null 2>&1; then
  HAS_TAG=false
  echo "No release tag found. Using unstable versioning." >&2
fi

# ---- バージョンとリビジョンを決定 ----

if [ "$HAS_TAG" = true ]; then
  echo "Fetching release info for $OWNER/$REPO..." >&2
  RELEASE=$(gh release view --repo "$OWNER/$REPO" --json tagName)
  TAG=$(echo "$RELEASE" | jq -r '.tagName')
  VERSION="${TAG#v}"
  echo "  version: $VERSION" >&2
else
  VERSION="unstable-$(date +%Y-%m-%d)"
  COMMIT_HASH=$(gh api "repos/$OWNER/$REPO/commits/HEAD" --jq '.sha')
  echo "  version: $VERSION" >&2
  echo "  commit: $COMMIT_HASH" >&2
fi

# ---- メタデータを取得 ----

REPO_INFO=$(gh api "repos/$OWNER/$REPO" 2>/dev/null || echo '{}')
DESCRIPTION=$(echo "$REPO_INFO" | jq -r '.description // "TODO: add description"')
SPDX=$(echo "$REPO_INFO" | jq -r '.license.spdx_id // "unknown"')
NIX_LICENSE=$(spdx_to_nix "$SPDX")

# ---- ファイルを生成 ----

mkdir -p "$PKG_DIR"

if [ "$HAS_TAG" = true ]; then
  cat > "$PKG_DIR/default.nix" << EOF
{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  # TODO: add runtime dependencies
  # gum,
  # git,
  # jq,
}:

stdenv.mkDerivation rec {
  pname = "$PNAME";
  version = "$VERSION";

  src = fetchFromGitHub {
    owner = "$OWNER";
    repo = "$REPO";
    tag = "v\${version}";
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $SCRIPT_NAME \$out/bin/$SCRIPT_NAME
    wrapProgram \$out/bin/$SCRIPT_NAME \\
      --prefix PATH : \${
        lib.makeBinPath [
          # TODO: add runtime dependencies
        ]
      }
    runHook postInstall
  '';

  meta = with lib; {
    description = "$DESCRIPTION";
    homepage = "https://github.com/$OWNER/$REPO";
    license = $NIX_LICENSE;
    mainProgram = "$PNAME";
  };
}
EOF
else
  cat > "$PKG_DIR/default.nix" << EOF
{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  # TODO: add runtime dependencies
  # gum,
  # git,
  # jq,
}:

stdenv.mkDerivation rec {
  pname = "$PNAME";
  version = "$VERSION";

  src = fetchFromGitHub {
    owner = "$OWNER";
    repo = "$REPO";
    rev = "$COMMIT_HASH";
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $SCRIPT_NAME \$out/bin/$SCRIPT_NAME
    wrapProgram \$out/bin/$SCRIPT_NAME \\
      --prefix PATH : \${
        lib.makeBinPath [
          # TODO: add runtime dependencies
        ]
      }
    runHook postInstall
  '';

  meta = with lib; {
    description = "$DESCRIPTION";
    homepage = "https://github.com/$OWNER/$REPO";
    license = $NIX_LICENSE;
    mainProgram = "$PNAME";
  };
}
EOF
fi

# ---- update.sh を生成 ----

if [ "$HAS_TAG" = true ]; then
  cat > "$PKG_DIR/update.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
pkg="$(basename "$(pwd)")"
nix run nixpkgs#nix-update -- --flake --override-filename "nix/packages/$pkg/default.nix" "$pkg"
EOF
else
  cat > "$PKG_DIR/update.sh" << EOF
#!/usr/bin/env bash
set -euo pipefail
cd "\$(dirname "\$0")"

echo "This package uses unstable versioning."
echo "To update manually:"
echo "  1. Get latest commit: gh api repos/$OWNER/$REPO/commits/HEAD --jq '.sha'"
echo "  2. Update 'rev' in default.nix with the new commit hash"
echo "  3. Update 'version' with current date: unstable-\$(date +%Y-%m-%d)"
echo "  4. Replace hash with lib.fakeHash, then: nix build .#$PNAME 2>&1 | grep 'got:'"
EOF
fi

chmod +x "$PKG_DIR/update.sh"

git -C "$REPO_ROOT" add "$PKG_DIR"

echo "Generated: $PKG_DIR/{default.nix,update.sh}" >&2
echo "Next steps:" >&2
echo "  1. Update TODO placeholders in default.nix with actual dependencies" >&2
echo "  2. Add to flake.nix (perSystem + overlay)" >&2
echo "  3. nix build .#$PNAME 2>&1 | grep 'got:' -> replace src.hash" >&2
echo "  4. nix build .#$PNAME -> confirm build succeeds" >&2
