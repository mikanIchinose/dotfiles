#!/usr/bin/env bash
# rust & cargo周りのインストール

set -e

# load utility functions
DIR=$(dirname "$0")
cd "$DIR"
. ../utils/functions.sh

info "setup rust"

if command -v rustup &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  export PATH="$HOME/.cargo/bin:$PATH"
  source "$HOME/.cargo/env"
else
  rustup self update
  rustup update
fi

# install rust apps
cargo_tools=(
  "starship" 
  "fd-find" 
  "exa" 
  "bat" 
  "xsv"
  "cargo-update" 
  "cargo-edit"
)
for tool in "${cargo_tools[@]}"; do
  cargo install "$tool"
done
cargo install-update -a
for tool in "${cargo_tools[@]}"; do
  $tool --version
done

success "Finished"
