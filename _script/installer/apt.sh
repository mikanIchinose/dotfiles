#!/usr/bin/env bash

echo "--------- apt ---------"
sudo apt install \
  fcitx-mozc \
  i3
echo -e "\n--------- Finished!! ---------\n"
fcitx --version
i3 --version
echo ""
read -rsp "続けるにはEnterを押してください: "
