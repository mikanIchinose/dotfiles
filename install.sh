#!/usr/bin/env bash

set -e
set -u

# install xcode command line tools
pathXCodeCommandLineTools=$(xcode-select -p 2>&1)
if ["$pathXCodeCommandLineTools" != "/Library/Developer/CommandLineTools"]; then
  echo "xcode-select --install"
  xcode-select --install
  read -p "Installing XCode Command Line Tools..."
fi
# install rosetta
echo "softwareupdate --install-rosetta"
softwareupdate --install-rosetta
# install nix
if ! command -v nix 2>&1 >/dev/null
then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
# clone dotfiles
nix-shell -p git --run "git clone https://github.com/mikanIchinose/dotfiles.git ~/dotfiles"
nix run nix-darwin -- switch --flake ~/dotfiles#mikan
# install dotfiles
/run/current-system/sw/bin/go install github.com/rhysd/dotfiles
~/go/bin/dotfiles link ~/dotfiles
