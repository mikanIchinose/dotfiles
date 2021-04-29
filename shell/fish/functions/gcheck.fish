function gcheck
  set branch (git branch | fzf --prompt "Branch> " | sed "s/^[*]//" | sed -e "s/^[ \t]*//")
  if test -n "$branch"
    git checkout "$branch"
  end
end
