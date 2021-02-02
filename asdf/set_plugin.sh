#!/usr/bin/env bash

node(){
  bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
}
php(){
  sudo apt update
  sudo apt install -y autoconf bison build-essential curl gettext git libgd-dev libcurl4-openssl-dev libedit-dev libicu-dev libjpeg-dev libmysqlclient-dev libonig-dev libpng-dev libpq-dev libreadline-dev libsqlite3-dev libssl-dev libxml2-dev libzip-dev openssl pkg-config re2c zlib1g-dev
}

node
php
