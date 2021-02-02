#!/bin/bash

# シンボリックリンクの作成
make_shim()
{
  target=~/.dotfiles/$1
  link_path=$2
  echo "$targetのシンボリックリンクを作成します"
  if [ -f "$link_path" ]; then
    rm -f $link_path
  fi
  ln -sf $target $link_path
}

make_shim .gitconfig ~/.gitconfig
make_shim tmux/.tmux.conf ~/.tmux.conf
make_shim nvim ~/.config/nvim
make_shim starship/starship.toml ~/.config/starship.toml
make_shim asdf/.tool-versions ~/.tool-versions
make_shim shell/.profile ~/.profile
make_shim shell/.bashrc ~/.bashrc
make_shim shell/fish ~/.config/fish
