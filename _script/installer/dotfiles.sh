#!/usr/bin/env bash

echo -e "\n--------- dotfiles ---------\n"
cd ~ || exit
if [ ! -d ~/.dotfiles ]; then
  git clone "git@github.com:mikanIchinose/dotfiles.git" ~/.dotfiles
fi
cd ~/.dotfiles || exit
bash ./create_links.sh
read -rsp "dotfilesに対して追加の作業が必要な場合は終わってからEnterを押してください: "
echo -e "\n--------- Finished!! ---------\n"
ls -al ~/.dotfiles
echo ""
read -rsp "続けるにはEnterを押してください: "
