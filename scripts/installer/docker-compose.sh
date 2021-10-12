#!/usr/bin/env bash

set -e
# load utility functions
DIR=$(dirname "$0")
cd "$DIR"
. ../utils/functions.sh

# main
info "setup docker-compose"

version="1.29.2"
url="https://github.com/docker/compose/releases/download/$version/docker-compose-$(uname -s)-$(uname -m)"
output="$HOME/.local/bin/docker-compose"

if command -v docker-compose &>/dev/null; then
  info "docker-composeはインストール済み"
  rm "$output"
fi

curl \
  -L "$url" \
  -o "$output"
chmod +x "$output"

docker-compose --version
success "Finished"
