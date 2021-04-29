#!/bin/bash

# シンボリックリンクの作成
make_shim()
{
  target_name=$1
  link_name=$2
  echo "create symbolic link: ${link_name}<-${target_name}"
  if [ -e "$link_name" ]; then
    rm -f "$link_name"
  fi
  ln -sf "$target_name" "$link_name"
}

make_shim ~/.dotfiles/.gitconfig ~/.gitconfig
make_shim ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
make_shim ~/.dotfiles/nvim ~/.config/nvim
make_shim ~/.dotfiles/starship.toml ~/.config/starship.toml
make_shim ~/.dotfiles/shell/fish ~/.config/fish

if [ `uname` == 'Darwin' ]; then
  make_shim ~/.dotfiles/.tool-versions.darwin ~/.tool-versions
elif [ `uname` == 'Linux' ]; then
  make_shim ~/.dotfiles/.tool-versions.linux ~/.tool-versions
  make_shim ~/.dotfiles/i3 ~/.config/i3
  make_shim ~/.dotfiles/i3blocks ~/.config/i3blocks
  make_shim ~/.dotfiles/shell/.bashrc ~/.bashrc
  make_shim ~/.dotfiles/shell/.profile ~/.profile
fi
