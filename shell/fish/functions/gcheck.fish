function gcheck
  set branch (git branch | fzf --prompt "Branch> " | sed "s/^ *\| *\$//")
  if test -n "$branch"
    git checkout "$branch"
  end
end

function gremote
  set remote_branch (git branch -r | fzf --prompt "Remote Branch> " | head -n 1 | sed -e "s/^\*\s*//g")
  if test -n "$remote_branch" 
    git checkout -t
  end
end
