abbr pass "set key (yq e 'keys' /Volumes/TOSHIBA/password.yml | sed 's/- //' | fzf | sed 's/^/\./') && yq e \$key /Volumes/TOSHIBA/password.yml"
