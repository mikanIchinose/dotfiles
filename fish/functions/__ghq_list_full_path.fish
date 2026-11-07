function __ghq_list_full_path -d 'Fast replacement for `ghq list --full-path`'
    # ghq.root と ghq.<url>.root の両方を収集
    set -l roots (git config --get ghq.root) \
        (git config --get-regexp 'ghq\..*\.root' 2>/dev/null | awk '{print $2}')

    # ~ 展開 + 実在ディレクトリのみ + 重複除去
    set -l expanded
    for r in $roots
        set -l path (string replace -r '^~' $HOME -- $r)
        test -d $path; and set expanded $expanded $path
    end
    set -l unique_roots (printf '%s\n' $expanded | sort -u)
    test -z "$unique_roots"; and return

    if type -qf fd
        fd -H --max-depth 4 '^\.git$' $unique_roots 2>/dev/null \
            | sed -E 's|/\.git/?$||'
    else
        ghq list --full-path
    end
end
