#!/usr/bin/env bash
set -euo pipefail

WEZTERM_REPO="/tmp/wezterm"

if [ -d "$WEZTERM_REPO/.git" ]; then
  echo "wezterm source already exists at $WEZTERM_REPO"
else
  echo "Cloning wezterm source to $WEZTERM_REPO..."
  git clone --depth 1 https://github.com/wezterm/wezterm.git "$WEZTERM_REPO"
  echo "Done."
fi

echo "Source docs: $WEZTERM_REPO/docs/"
