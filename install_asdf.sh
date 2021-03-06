#!/usr/bin/env bash
sudo apt install curl git
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0

node(){
  bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
}
php(){
  sudo apt update
  sudo apt install -y autoconf bison build-essential curl gettext git libgd-dev libcurl4-openssl-dev libedit-dev libicu-dev libjpeg-dev libmysqlclient-dev libonig-dev libpng-dev libpq-dev libreadline-dev libsqlite3-dev libssl-dev libxml2-dev libzip-dev openssl pkg-config re2c zlib1g-dev
  if command -v brew &> /dev/null; then
    brew install autoconf automake bison freetype gd gettext icu4c krb5 libedit libiconv libjpeg libpng libxml2 libzip pkg-config re2c zlib
  fi
}

node
php

# install plugins
cat < ~/.tool-versions | awk '{print $1}' | while read -r plugin
do
  asdf add "$plugin"
done
