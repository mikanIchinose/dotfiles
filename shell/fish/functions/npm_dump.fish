function npm_dump
  npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > $HOME/.dotfiles/npmfile.darwin
end
