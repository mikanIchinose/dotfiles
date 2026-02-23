#!/usr/bin/env bash
set -euo pipefail
pkg="$(basename "$(cd "$(dirname "$0")" && pwd)")"
cd "$(git rev-parse --show-toplevel)"
nix run nixpkgs#nix-update -- --flake --override-filename "nix/packages/$pkg/default.nix" "$pkg"
