#!/usr/bin/env bash

set -e

DL_DIR=$HOME/ダウンロード
URI=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
DEB=google-chrome-stable_current_amd64.deb

wget $URI -P "$DL_DIR"
cd "$DL_DIR" || exit
sudo apt install ./$DEB
rm -i "$DL_DIR/$DEB"
cd ~ || exit
