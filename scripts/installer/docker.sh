#!/usr/bin/env bash
set -e

# load utility functions
DIR=$(dirname "$0")
cd "$DIR"
. ../utils/functions.sh

info "setup docker"

if command -v docker &> /dev/null; then
  info "dockerはインストール済み"
else
  sudo apt update
  sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io
  sudo docker --version
  sudo usermod -aG docker "$USER"
  newgrp docker

  docker --version
fi
success "Finished"
docker --version
read -rsp "続けるにはEnterを押してください: "
