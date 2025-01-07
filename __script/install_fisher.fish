#!/usr/bin/env fish

set --local plugins (read --null <~/dotfiles/fishfile)
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher install $plugins
