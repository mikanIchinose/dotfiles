#!/usr/bin/env bash
# macOS (aarch64-darwin) 向けプリビルドバイナリの Nix パッケージを初期化する。
# GitHub リリース情報を取得して nix/packages/<pname>/{default.nix,update.sh} を生成する。
#
# 使い方: init-binary.sh <pname> <owner> <repo>
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
RELEASE=$(gh release view --repo "$OWNER/$REPO" --json tagName,assets)
TAG=$(echo "$RELEASE" | jq -r '.tagName')
VERSION=$(echo "$TAG" | sed 's/^v//')

# aarch64-darwin アセットをアセット名のパターンで検索
ASSET=$(echo "$RELEASE" | jq -r \
  '[.assets[].name | select(test("aarch64[._-]apple[._-]darwin|aarch64[._-]macos"))] | first // ""')

if [ -z "$ASSET" ]; then
  echo "ERROR: no aarch64-darwin asset found. Available assets:" >&2
  echo "$RELEASE" | jq -r '.assets[].name' | sed 's/^/  /' >&2
  exit 1
fi

echo "  version: $VERSION  asset: $ASSET" >&2

# ---- メタデータを取得 ----

# リポジトリの description と SPDX ライセンス識別子を取得し、Nix の licenses.* 形式に変換
REPO_INFO=$(gh api "repos/$OWNER/$REPO" 2>/dev/null || echo '{}')
DESCRIPTION=$(echo "$REPO_INFO" | jq -r '.description // "TODO: add description"')
SPDX=$(echo "$REPO_INFO" | jq -r '.license.spdx_id // "unknown"')
NIX_LICENSE=$(spdx_to_nix "$SPDX")

# ---- ハッシュを取得 ----

echo "Fetching hash: $ASSET..." >&2
HASH=$(nix store prefetch-file --json \
  "https://github.com/$OWNER/$REPO/releases/download/$TAG/$ASSET" | jq -r '.hash')
echo "  $HASH" >&2

# ---- ファイルを生成 ----

mkdir -p "$PKG_DIR"

# アセット名にバージョン文字列が含まれる場合、Nix 用は ${version}、update.sh 用は ${LATEST} に置換する
ASSET_NAME_NIX=$(version_template "$ASSET" '${version}')
URL_NIX="https://github.com/$OWNER/$REPO/releases/download/v\${version}/$ASSET_NAME_NIX"
ASSET_NAME_SH=$(version_template "$ASSET" '${LATEST}')
URL_SH="https://github.com/$OWNER/$REPO/releases/download/v\${LATEST}/$ASSET_NAME_SH"

cat > "$PKG_DIR/default.nix" << EOF
{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "$PNAME";
  version = "$VERSION";

  src = fetchurl {
    url = "$URL_NIX";
    hash = "$HASH";
  };

  installPhase = ''
    mkdir -p \$out/bin
    cp $PNAME \$out/bin/
  '';

  meta = with lib; {
    description = "$DESCRIPTION";
    homepage = "https://github.com/$OWNER/$REPO";
    license = $NIX_LICENSE;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "$PNAME";
  };
}
EOF

cat > "$PKG_DIR/update.sh" << EOF
#!/usr/bin/env bash
set -euo pipefail
cd "\$(dirname "\$0")"

LATEST=\$(gh release view --repo $OWNER/$REPO --json tagName -q '.tagName | ltrimstr("v")')
CURRENT=\$(sed -n 's/.*version = "\(.*\)".*/\1/p' default.nix)
[ "\$LATEST" = "\$CURRENT" ] && echo "$PNAME is up to date (\$CURRENT)" && exit 0

echo "Updating $PNAME: \$CURRENT -> \$LATEST"
HASH=\$(nix store prefetch-file --json "$URL_SH" | jq -r '.hash')
sed -i '' "s/version = \".*\"/version = \"\$LATEST\"/" default.nix
sed -i '' "s|hash = \".*\"|hash = \"\$HASH\"|" default.nix
EOF

chmod +x "$PKG_DIR/update.sh"

echo "Generated: $PKG_DIR/{default.nix,update.sh}" >&2
echo "Next: review installPhase, add to flake.nix, nix build .#$PNAME" >&2
