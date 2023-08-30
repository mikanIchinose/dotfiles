#!/usr/bin/env bash
set -e

# load utility functions
DIR=$(dirname "$0")
cd "$DIR"
. ../utils/functions.sh

info "setup homebrew"

if [ ! -d /home/linuxbrew ]; then
  sudo apt install build-essential file curl git
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin"
cd ~ || exit
brew --version && brew bundle

success "Finished"
