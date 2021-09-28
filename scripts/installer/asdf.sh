#!/usr/bin/env bash

set -e

# load utility functions
DIR=$(dirname "$0")
cd "$DIR"
. ../utils/functions.sh

node(){
  bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
}

php(){
  sudo apt update
  sudo apt upgrade
  sudo apt install -y autoconf bison build-essential curl gettext git libgd-dev libcurl4-openssl-dev libedit-dev libicu-dev libjpeg-dev libmysqlclient-dev libonig-dev libpng-dev libpq-dev libreadline-dev libsqlite3-dev libssl-dev libxml2-dev libzip-dev openssl pkg-config re2c zlib1g-dev
}

# main
info "setup asdf"

sudo apt install -y curl git
if [ ! -d ~/.asdf ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
fi
export PATH="$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"

node
php
# install plugins
if [ -e ~/.tool-versions ]; then
  cat < ~/.tool-versions | awk '{print $1}' | while read -r plugin
  do
    asdf plugin add "$plugin"
  done
fi

asdf --version
asdf plugin list
read -rsp "続けるにはEnterを押してください: "
cd ~ || exit
asdf install
asdf list all

success "Finished"
