#!/usr/bin/env bash

echo "install xcode command line tools if needed"
pathXCodeCommandLineTools=$(xcode-select -p 2>&1)
if [ "$pathXCodeCommandLineTools" != "/Library/Developer/CommandLineTools" ]; then
  echo "xcode-select --install"
  xcode-select --install
fi

# install rosetta
echo "softwareupdate --install-rosetta"
softwareupdate --install-rosetta

echo "install nix if needed"
if ! command -v /run/current-system/sw/bin/nix 2>&1 >/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
fi
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# clone dotfiles
nix-shell -p git --run "git clone --depth 1 https://github.com/mikanIchinose/dotfiles.git ~/dotfiles"

echo "nix run nix-darwin -- switch --flake ~/dotfiles#mikan"
nix run nix-darwin -- switch --flake ~/dotfiles#mikan

# link dotfiles
/run/current-system/sw/bin/go install github.com/rhysd/dotfiles@latest
~/go/bin/dotfiles link ~/dotfiles

# gh auth login
/run/current-system/sw/bin/gh auth login

# install go tools
for var in $(cat ~/dotfiles/gofile)
do
  /run/current-system/sw/bin/go install "$var"
done
# install rust tools
for var in $(cat ~/dotfiles/cargofile)
do
  /run/current-system/sw/bin/cargo install $var
done

# import ghq repositories
cat ~/local/.ghqfile | /run/current-system/sw/bin/ghq get --parallel --update --shallow

# startup gui
open /Applications/Rectangle.app
open /Applications/Raycast.app
open /Applications/JetBrains\ Toolbox.app
open /Applications/Notion.app
open /Applications/Notion\ Calendar.app
open /Applications/Karabiner-Elements.app
