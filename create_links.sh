#!/bin/bash

# シンボリックリンクの作成
make_shim()
{
  target=$1
  link_path=$2
  echo "${target}のシンボリックリンクを作成します"
  if [ -e "$link_path" ]; then
    rm -f "$link_path"
  fi
  ln -sf "$target" "$link_path"
}

make_shim ~/.dotfiles/.gitconfig ~/.gitconfig
make_shim ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
make_shim ~/.dotfiles/nvim ~/.config/nvim
make_shim ~/.dotfiles/starship/starship.toml ~/.config/starship.toml
make_shim ~/.dotfiles/asdf/.tool-versions ~/.tool-versions
make_shim ~/.dotfiles/shell/.profile ~/.profile
make_shim ~/.dotfiles/shell/.bashrc ~/.bashrc
make_shim ~/.dotfiles/shell/fish ~/.config/fish
make_shim ~/.dotfiles/i3 ~/.config/i3
make_shim ~/.dotfiles/i3blocks ~/.config/i3blocks
