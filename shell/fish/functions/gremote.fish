function gremote
  set remote_branch (git branch -r | fzf --prompt "Remote Branch> " | head -n 1 | sed -e "s/^\*\s*//g" | sed -e "s/^[ \t]*//")
  if test -n "$remote_branch" 
    git checkout -t "$remote_branch"
  end
end
