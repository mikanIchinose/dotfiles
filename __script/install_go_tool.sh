#!/usr/bin/env bash

set -e
set -u

# install go tools
for var in $(cat ~/dotfiles/gofile)
do
  /run/current-system/sw/bin/go install "$var"
done
