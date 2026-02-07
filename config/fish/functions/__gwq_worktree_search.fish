function __gwq_worktree_search -d 'Git worktree search with gwq'
    if not type -qf gwq
        printf "\nERROR: 'gwq' not found.\n"
        return 1
    end

    set -l select (gwq get)
    [ -n "$select" ]; and cd "$select"
    commandline -f repaint
end
