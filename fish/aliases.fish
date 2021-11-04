# シェルの再起動
abbr reload "exec fish"

# exa
abbr e "exa"
abbr ei "exa -aF --icons"
abbr els "exa -alF --time-style=iso --icons"
abbr cl "clear"

# change owner to me
abbr chown "sudo chown -R $USER:$USER ."

# git
abbr g "git"
# abbr gc "git checkout"
abbr gb "git branch"
abbr ga "git add "
abbr gc "git commit"
abbr gst "git status -sb"
# alias gstf "__mikan_git_stash_fzf"
abbr gsp "git stash pop "
abbr gsa "git stash apply "
abbr gsd "git stash drop "
abbr gps "git push"
abbr gpl "git pull"
abbr gpr "git pull --rebase origin develop"
abbr grc "git rebase --continue"
abbr gm "git merge"
abbr gmd "git merge develop"
abbr gf "git fetch origin"
# alias gwf "__mikan_git_worktree_add_fzf"
abbr gwr "git worktree remove "
abbr gwl "git worktree list "
# alias gswf "__mikan_git_switch_fzf"
abbr gsw "git switch -c "

# edit config file
alias setzsh "vim ~/.zshrc"
alias setbash "vim ~/.bashrc"
alias setfish "cd ~/.config/fish; vim (fzf); cd -"
alias setvim "cd ~/.config/nvim; vim (fzf); cd -"
alias settmux "vim ~/.tmux.conf"
alias setstar "vim $STARSHIP_CONFIG"

# tmux
# alias t "tmux" # start session
# alias ta "tmux attach" # attach session
# alias tsh "tmux split-window -h" # split horizontal
# alias tsv "tmux split-window -v" # split vertical
# alias tks "tmux kill-server" # stop tmux server

# docker
abbr d "docker"
abbr dps "docker container ls --format \"table {{.Names}}\t{{.Ports}}\""
# docker-compose
abbr dc "docker-compose"
abbr dup "docker-compose up -d"
abbr dd "docker-compose down"
abbr dk "docker-compose down --rmi all --volumes --remove-orphans"
alias dreload "ddown && dup"
abbr dex "docker-compose exec"
abbr dcr "docker-compose run"
abbr dcb "docker-compose build"

alias vim "nvim"

abbr bash "bash --norc"
abbr zsh "zsh --norc"

abbr tree "exa --tree"
