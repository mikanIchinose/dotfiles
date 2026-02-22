#!/usr/bin/env bash
# npm パッケージ向け Nix パッケージを初期化する。
# npm view でメタデータを取得して nix/packages/<pname>/{default.nix,package.json,package-lock.json,update.sh} を生成する。
#
# 使い方: init-npm.sh <pname> <npm-package-name>
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <pname> <npm-package-name>" >&2
  exit 1
fi
PNAME="$1"
NPM_PKG="$2"

SCRIPTS_DIR="$(dirname "$0")"
REPO_ROOT="$(git -C "$SCRIPTS_DIR" rev-parse --show-toplevel)"
PKG_DIR="$REPO_ROOT/nix/packages/$PNAME"

# shellcheck source=lib.sh
source "$SCRIPTS_DIR/lib.sh"

# ---- npm メタデータを取得 ----

echo "Fetching npm metadata for $NPM_PKG..." >&2

VERSION=$(npm view "$NPM_PKG" version)
DESCRIPTION=$(npm view "$NPM_PKG" description 2>/dev/null || echo "TODO: add description")
HOMEPAGE=$(npm view "$NPM_PKG" homepage 2>/dev/null || echo "")
SPDX=$(npm view "$NPM_PKG" license 2>/dev/null || echo "unknown")
NIX_LICENSE=$(spdx_to_nix "$SPDX")

echo "  version: $VERSION" >&2
echo "  description: $DESCRIPTION" >&2
echo "  license: $SPDX -> $NIX_LICENSE" >&2

# ---- bin 情報を取得 ----

BIN_JSON=$(npm view "$NPM_PKG" bin --json 2>/dev/null || echo '{}')
FIRST_BIN_NAME=$(echo "$BIN_JSON" | jq -r 'keys[0] // empty')
FIRST_BIN_PATH=$(echo "$BIN_JSON" | jq -r 'to_entries[0].value // empty')

echo "  bin: $FIRST_BIN_NAME -> $FIRST_BIN_PATH" >&2

# ---- スコープ判定 ----

IS_SCOPED=false
SCOPE=""
PKG_SHORT="$NPM_PKG"
if [[ "$NPM_PKG" == @*/* ]]; then
  IS_SCOPED=true
  SCOPE="${NPM_PKG%%/*}"
  PKG_SHORT="${NPM_PKG#*/}"
fi

# ---- ファイルを生成 ----

mkdir -p "$PKG_DIR"

# package.json
cat > "$PKG_DIR/package.json" << EOF
{
  "name": "$PNAME-wrapper",
  "version": "$VERSION",
  "private": true,
  "dependencies": {
    "$NPM_PKG": "$VERSION"
  }
}
EOF

# package-lock.json
echo "Generating package-lock.json..." >&2
(cd "$PKG_DIR" && npm install --package-lock-only) >&2

# default.nix - installPhase はスコープ有無で変わる
if [ "$IS_SCOPED" = true ]; then
  INSTALL_PHASE="    runHook preInstall

    mkdir -p \$out/bin \$out/lib/node_modules/$SCOPE
    cp -r node_modules/$SCOPE/$PKG_SHORT \$out/lib/node_modules/$SCOPE/
    ln -s \$out/lib/node_modules/$SCOPE/$PKG_SHORT/${FIRST_BIN_PATH:-bin/$FIRST_BIN_NAME} \$out/bin/$PNAME
    chmod +x \$out/bin/$PNAME

    runHook postInstall"
else
  INSTALL_PHASE="    runHook preInstall

    mkdir -p \$out/bin \$out/lib/node_modules
    cp -r node_modules/$NPM_PKG \$out/lib/node_modules/
    ln -s \$out/lib/node_modules/$NPM_PKG/${FIRST_BIN_PATH:-bin/$FIRST_BIN_NAME} \$out/bin/$PNAME

    runHook postInstall"
fi

# homepage が空の場合は npm レジストリの URL を使う
if [ -z "$HOMEPAGE" ]; then
  HOMEPAGE="https://www.npmjs.com/package/$NPM_PKG"
fi

cat > "$PKG_DIR/default.nix" << EOF
{
  lib,
  buildNpmPackage,
  nodejs_24,
}:

buildNpmPackage {
  pname = "$PNAME";
  version = "$VERSION";

  src = ./.;

  npmDepsHash = lib.fakeHash;

  nodejs = nodejs_24;

  dontNpmBuild = true;
  dontNpmInstall = true;

  installPhase = ''
$INSTALL_PHASE
  '';

  meta = with lib; {
    description = "$DESCRIPTION";
    homepage = "$HOMEPAGE";
    license = $NIX_LICENSE;
    mainProgram = "$PNAME";
  };
}
EOF

# update.sh
cat > "$PKG_DIR/update.sh" << EOF
#!/usr/bin/env bash
set -euo pipefail
cd "\$(dirname "\$0")"

PKG="$NPM_PKG"
LATEST=\$(npm view "\$PKG" version)
CURRENT=\$(jq -r '.version' package.json)
[ "\$LATEST" = "\$CURRENT" ] && echo "\$PKG is up to date (\$CURRENT)" && exit 0

echo "Updating \$PKG: \$CURRENT -> \$LATEST"
jq --arg v "\$LATEST" '.version = \$v | .dependencies["$NPM_PKG"] = \$v' package.json > package.json.tmp
mv package.json.tmp package.json
npm install --package-lock-only
NEW_HASH=\$(nix run nixpkgs#prefetch-npm-deps -- package-lock.json 2>/dev/null)
sed -i '' "s/version = \".*\"/version = \"\$LATEST\"/" default.nix
sed -i '' "s|npmDepsHash = \".*\"|npmDepsHash = \"\$NEW_HASH\"|" default.nix
EOF

chmod +x "$PKG_DIR/update.sh"

git -C "$REPO_ROOT" add "$PKG_DIR"

echo "" >&2
echo "Generated: $PKG_DIR/{default.nix,package.json,package-lock.json,update.sh}" >&2
echo "Next steps:" >&2
echo "  1. Add to flake.nix (perSystem + overlay)" >&2
echo "  2. git add nix/packages/$PNAME flake.nix" >&2
echo "  3. nix build .#$PNAME 2>&1 | grep 'got:' -> replace npmDepsHash" >&2
echo "  4. Review installPhase (check bin path with: npm view $NPM_PKG bin --json)" >&2
echo "  5. nix build .#$PNAME -> confirm build succeeds" >&2
