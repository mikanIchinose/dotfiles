#!/usr/bin/env bash

set -e
# load utility functions
DIR=$(dirname "$0")
cd "$DIR"
. ../utils/functions.sh

info "setup docker-compose"

if command -v docker-compose &> /dev/null; then
  info "docker-composeはインストール済み"
  docker-compose migrate-to-labels
else
  curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o ~/.local/bin/docker-compose
  chmod +x ~/.local/bin/docker-compose
fi
success "Finished"
docker-compose --version
echo ""
read -rsp "続けるにはEnterを押してください: "
