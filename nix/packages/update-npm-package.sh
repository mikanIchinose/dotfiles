#!/usr/bin/env bash
# Usage: ./update-npm-package.sh <package-dir>
# Example: ./update-npm-package.sh copilot-language-server

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="${SCRIPT_DIR}/${1:?Usage: $0 <package-dir>}"

if [[ ! -d "$PACKAGE_DIR" ]]; then
  echo "Error: Directory not found: $PACKAGE_DIR" >&2
  exit 1
fi

cd "$PACKAGE_DIR"

echo "==> Updating package-lock.json..."
npm install --package-lock-only

echo "==> Calculating npmDepsHash..."
HASH=$(nix shell nixpkgs#prefetch-npm-deps -c prefetch-npm-deps package-lock.json 2>/dev/null)

echo ""
echo "==> Update default.nix with:"
echo "    npmDepsHash = \"$HASH\";"
echo ""
echo "==> Done. Don't forget to update 'version' in default.nix if needed."
