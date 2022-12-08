# シェルの再起動
abbr reload "exec fish"

abbr cl "clear"

# change owner to me
abbr chown "sudo chown -R $USER:$USER ."

# git
abbr g "git"
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
alias setfish "cd ~/.config/fish; vim (fd --type file | fzf); cd -"
alias setvim "cd ~/.config/nvim; vim (fd --type file | fzf); cd -"
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
abbr novim "nvim -u NONE"

abbr bash "bash --norc"
abbr zsh "zsh --no-rcs"

abbr tree "exa --tree"

abbr denops 'deno run -A --no-check ~/.cache/dein/repos/github.com/vim-denops/denops.vim/denops/@denops-private/cli.ts'

# better cli
if type -q bat &> /dev/null
  alias cat "bat"
end
if type -q fd &> /dev/null
  alias find "fd"
end
if type -q rg &> /dev/null
  alias grep "rg"
end
if type -q exa &> /dev/null
  alias ls "exa"
  abbr ll "exa -al"
end
