#!/usr/bin/env bash

set -e
set -u

# install xcode command line tools
xcode-select --install
# install rosetta
softwareupdate --install-rosetta
# install nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
# clone dotfiles
nix-shell -p git --run "git clone https://github.com/mikanIchinose/dotfiles.git ~/dotfiles"
nix run nix-darwin -- switch --flake ~/dotfiles#mikan
# install dotfiles
go install github.com/rhysd/dotfiles
~/go/bin/dotfiles link ~/dotfiles
