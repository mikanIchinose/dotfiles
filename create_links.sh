#! /usr/bin/env bash

set -e

DIR=$(dirname "$0")
cd "$DIR"

. ./utils/functions.sh

info "make shimlinks"

symlink "${HOME}/.dotfiles/tmux/.tmux.conf" "${HOME}/.tmux.conf"
symlink "${HOME}/.dotfiles/nvim"            "${HOME}/.config/nvim"
symlink "${HOME}/.dotfiles/starship.toml"   "${HOME}/.starship/config.toml"
symlink "${HOME}/.dotfiles/fish"            "${HOME}/.config/fish"
symlink "${HOME}/.dotfiles/.tigrc"          "${HOME}/.tigrc"

if [ `uname` == 'Darwin' ]; then
  symlink "${HOME}/.dotfiles/asdf/darwin/.tool-versions" "${HOME}/.tool-versions"
elif [ `uname` == 'Linux' ]; then
  symlink "${HOME}/.dotfiles/asdf/linux/.tool-versions"  "${HOME}/.tool-versions"
  symlink "${HOME}/.dotfiles/i3"                         "${HOME}/.config/i3"
  symlink "${HOME}/.dotfiles/i3blocks"                   "${HOME}/.config/i3blocks"
  symlink "${HOME}/.dotfiles/shell/.bashrc"              "${HOME}/.bashrc"
  symlink "${HOME}/.dotfiles/shell/.profile"             "${HOME}/.profile"
fi

success "Finished"
