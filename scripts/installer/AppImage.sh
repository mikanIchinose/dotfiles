#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# todo: まだ未完成
set -e

DIR=$(dirname "$0")
cd "$DIR"
. ../utils/functions.sh

info "setup AppImage"

if [ -d ~/AppImage ]; then
  app_images=$(ls ~/AppImage)
  for app_image in $app_images; do
    chmod +x "$app_images"
    ln -sf ~/AppImage/"$app_image" ~/.local/bin/"$app_image"
  done
fi

nvim --version
read -rsp "続けるにはEnterを押してください: "

success "Finished"
