#!/usr/bin/env bash

set -e

switch (uname)
case Linux
    cd ~/AppImage &&
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage &&
    mv nvim.appimage nvim &&
    chmod u+x nvim
case Darwin
    curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
    tar xzf nvim-macos.tar.gz
end
