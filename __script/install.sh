#!/usr/bin/env bash

set -e
set -u

# xcode command line toolsをインストール
xcode-select --install
# google日本語入力用
sudo softwareupdate --install-rosetta
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
# setup dotfiles
brew install go
go install github.com/rhysd/dotfiles@latest
~/go/bin/dotfiles clone --https mikanIchinose/dotfiles ~
~/go/bin/dotfiles link ~/dotfiles
# install softwares from homebrew
brew bundle
# install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# install deno
curl -fsSL https://deno.land/x/install/install.sh | sh
# install bun
curl -fsSL https://bun.sh/install | bash
# install maestro
curl -Ls "https://get.maestro.mobile.dev" | bash
# install go tools
for var in $(cat ~/dotfiles/gofiles)
do
  go install "github.com/$var"
done
# install rust tools
for var in $(cat ~/dotfiles/cargofiles)
do
  cargo install $var
done
