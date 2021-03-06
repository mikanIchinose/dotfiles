function gcheck
  git checkout (git branch | fzf | sed "s/^ *\| *\$//")
end

function gremote
  git branch -r | fzf --prompt "Remote Branch> " | head -n 1 | sed -e "s/^\*\s*//g" | xargs git checkout -t
end
