function npm_restore
  switch (uname)
  case Linux
    set npmfile "$HOME/.dotfiles/npmfile.linux"
  case Darwin
    set npmfile "$HOME/.dotfiles/npmfile.darwin"
  end
  xargs npm install --global < $npmfile
end
