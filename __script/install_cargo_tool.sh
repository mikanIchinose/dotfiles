#!/usr/bin/env bash

set -e
set -u

# install rust tools
for var in $(cat ~/dotfiles/cargofile)
do
  /run/current-system/sw/bin/cargo install $var
done

