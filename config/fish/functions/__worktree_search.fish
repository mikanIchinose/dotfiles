function __worktree_search -d 'Worktree/workspace search with fzf'
    set -l selected (worktree-select)
    if [ -n "$selected" ]
        cd "$selected"
    end
    commandline -f repaint
end
