#!/usr/bin/env bash
# -*- coding: utf-8 -*-

read -rp "Firacode NF をインストールしましたか?(y/n): " answer
case "$answer" in
  [yY]*) echo 処理を続けます;;
  *) echo "処理を終了します"; exit 0;;
esac
cd ~ || exit
ghq get "https://github.com/jarun/nnn.git"
cd $(ghq root)/github.com/jarun/nnn || exit
sudo apt install pkg-config libncursesw5-dev libreadline-dev
sudo ln -s /lib/x86_64-linux-gnu/libncursesw.so.5 /lib/x86_64-linux-gnu/libncursesw.so.6
make O_NERD=1
mv ./nnn ~/.local/bin/nnn
