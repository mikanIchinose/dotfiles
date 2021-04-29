abbr update "brew upgrade; fisher update"

abbr pass "set key (yq e 'keys' /Volumes/TOSHIBA/password.yml | sed 's/- //' | fzf | sed 's/^/\./') && yq e \$key /Volumes/TOSHIBA/password.yml"

# brew
abbr bi "brew install"
