#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
pkg="$(basename "$(pwd)")"
nix run nixpkgs#nix-update -- --flake --override-filename "nix/packages/$pkg/default.nix" "$pkg"
