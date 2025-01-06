#!/usr/bin/env bash

set -e
set -u

# uninstall homebrew
brew uninstall --force $(brew list)
brew cleanup

# uninstall nix-darwin
nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller --no-confirm

# uninstall nix-store
nix-store --gc

# uninstall nix
/nix/nix-installer uninstall --no-confirm
