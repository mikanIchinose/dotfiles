function npm_dump
  switch (uname)
  case Linux
    set npmfile "$HOME/.dotfiles/npmfile.linux"
  case Darwin
    set npmfile "$HOME/.dotfiles/npmfile.darwin"
  end
  npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > $npmfile
end
