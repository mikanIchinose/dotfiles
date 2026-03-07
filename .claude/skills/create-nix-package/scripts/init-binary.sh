#!/usr/bin/env bash
# aarch64-darwin / x86_64-linux 向けプリビルドバイナリの Nix パッケージを初期化する。
# GitHub リリース情報を取得して nix/packages/<pname>/{default.nix,update.sh} を生成する。
#
# 使い方: init-binary.sh [--dry-run] <pname> <owner> <repo>
set -euo pipefail

DRY_RUN=false
while [[ "${1:-}" == --* ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [ $# -lt 3 ]; then
  echo "Usage: $0 [--dry-run] <pname> <owner> <repo>" >&2
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
ASSET_DARWIN=$(echo "$RELEASE" | jq -r \
  '[.assets[].name | select(test("aarch64[._-]apple[._-]darwin|aarch64[._-]macos"))] | first // ""')

if [ -z "$ASSET_DARWIN" ]; then
  echo "ERROR: no aarch64-darwin asset found. Available assets:" >&2
  echo "$RELEASE" | jq -r '.assets[].name' | sed 's/^/  /' >&2
  exit 1
fi

echo "  version: $VERSION  darwin asset: $ASSET_DARWIN" >&2

# x86_64-linux アセットを検索
ASSET_LINUX=$(echo "$RELEASE" | jq -r \
  '[.assets[].name | select(test("x86_64[._-](unknown[._-])?linux"))] | first // ""')

if [ -z "$ASSET_LINUX" ]; then
  echo "ERROR: no x86_64-linux asset found. Available assets:" >&2
  echo "$RELEASE" | jq -r '.assets[].name' | sed 's/^/  /' >&2
  exit 1
fi

echo "  linux asset: $ASSET_LINUX" >&2

# ---- メタデータを取得 ----

# リポジトリの description と SPDX ライセンス識別子を取得し、Nix の licenses.* 形式に変換
REPO_INFO=$(gh api "repos/$OWNER/$REPO" 2>/dev/null || echo '{}')
DESCRIPTION=$(echo "$REPO_INFO" | jq -r '.description // "TODO: add description"')
SPDX=$(echo "$REPO_INFO" | jq -r '.license.spdx_id // "unknown"')
NIX_LICENSE=$(spdx_to_nix "$SPDX")

# ---- ハッシュを取得 ----

if [ "$DRY_RUN" = true ]; then
  HASH_DARWIN="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
  HASH_LINUX="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
  echo "Skipping hash fetch (dry-run)" >&2
else
  echo "Fetching hash (darwin): $ASSET_DARWIN..." >&2
  HASH_DARWIN=$(nix store prefetch-file --json \
    "https://github.com/$OWNER/$REPO/releases/download/$TAG/$ASSET_DARWIN" | jq -r '.hash')
  echo "  $HASH_DARWIN" >&2

  echo "Fetching hash (linux): $ASSET_LINUX..." >&2
  HASH_LINUX=$(nix store prefetch-file --json \
    "https://github.com/$OWNER/$REPO/releases/download/$TAG/$ASSET_LINUX" | jq -r '.hash')
  echo "  $HASH_LINUX" >&2
fi

# ---- ファイルを生成 ----

emit_file() {
  local path="$1"
  if [ "$DRY_RUN" = true ]; then
    echo "--- $path ---"
    cat
    echo ""
  else
    cat > "$path"
  fi
}

if [ "$DRY_RUN" = false ]; then
  mkdir -p "$PKG_DIR"
fi

# アセット名にバージョン文字列が含まれる場合、Nix 用は ${version}、update.sh 用は ${LATEST} に置換する
ASSET_DARWIN_NAME_NIX=$(version_template "$ASSET_DARWIN" '${version}')
URL_DARWIN_NIX="https://github.com/$OWNER/$REPO/releases/download/v\${version}/$ASSET_DARWIN_NAME_NIX"
ASSET_DARWIN_NAME_SH=$(version_template "$ASSET_DARWIN" '${LATEST}')
URL_DARWIN_SH="https://github.com/$OWNER/$REPO/releases/download/v\${LATEST}/$ASSET_DARWIN_NAME_SH"

ASSET_LINUX_NAME_NIX=$(version_template "$ASSET_LINUX" '${version}')
URL_LINUX_NIX="https://github.com/$OWNER/$REPO/releases/download/v\${version}/$ASSET_LINUX_NAME_NIX"
ASSET_LINUX_NAME_SH=$(version_template "$ASSET_LINUX" '${LATEST}')
URL_LINUX_SH="https://github.com/$OWNER/$REPO/releases/download/v\${LATEST}/$ASSET_LINUX_NAME_SH"

emit_file "$PKG_DIR/default.nix" << EOF
{
  lib,
  stdenv,
  fetchurl,
}:

let
  sources = {
    "aarch64-darwin" = {
      url = "$URL_DARWIN_NIX";
      hash = "$HASH_DARWIN"; # hash-darwin
    };
    "x86_64-linux" = {
      url = "https://github.com/$OWNER/$REPO/releases/download/v\${version}/$ASSET_LINUX_NAME_NIX";
      hash = "$HASH_LINUX"; # hash-linux
    };
  };
  version = "$VERSION";
  src =
    sources.\${stdenv.hostPlatform.system}
      or (throw "unsupported system: \${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation {
  pname = "$PNAME";
  inherit version;

  src = fetchurl {
    inherit (src) url hash;
  };

  installPhase = ''
    mkdir -p \$out/bin
    cp $PNAME \$out/bin/
  '';

  meta = with lib; {
    description = "$DESCRIPTION";
    homepage = "https://github.com/$OWNER/$REPO";
    license = $NIX_LICENSE;
    platforms = builtins.attrNames sources;
    mainProgram = "$PNAME";
  };
}
EOF

emit_file "$PKG_DIR/update.sh" << EOF
#!/usr/bin/env bash
set -euo pipefail
cd "\$(dirname "\$0")"

LATEST=\$(gh release view --repo $OWNER/$REPO --json tagName -q '.tagName | ltrimstr("v")')
CURRENT=\$(sed -n 's/.*version = "\(.*\)".*/\1/p' default.nix | head -1)
[ "\$LATEST" = "\$CURRENT" ] && echo "$PNAME is up to date (\$CURRENT)" && exit 0

echo "Updating $PNAME: \$CURRENT -> \$LATEST"

# aarch64-darwin
HASH_DARWIN=\$(nix store prefetch-file --json "$URL_DARWIN_SH" | jq -r '.hash')

# x86_64-linux
HASH_LINUX=\$(nix store prefetch-file --json "$URL_LINUX_SH" | jq -r '.hash')

sed -i'' "s/version = \".*\"/version = \"\$LATEST\"/" default.nix
sed -i'' "s|hash = \".*\"; # hash-darwin|hash = \"\$HASH_DARWIN\"; # hash-darwin|" default.nix
sed -i'' "s|hash = \".*\"; # hash-linux|hash = \"\$HASH_LINUX\"; # hash-linux|" default.nix
EOF

if [ "$DRY_RUN" = false ]; then
  chmod +x "$PKG_DIR/update.sh"
fi

echo "Generated: $PKG_DIR/{default.nix,update.sh}" >&2
echo "Next: review installPhase, add to flake.nix, nix build .#$PNAME" >&2
