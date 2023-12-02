# シェルの再起動
abbr reload "exec fish"

abbr cl "clear"

# change owner to me
abbr chown "sudo chown -R $USER:$USER ."

# git
abbr g "git"
abbr gb "git branch"
abbr gst "git status -sb"
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
abbr gwr "git worktree remove "
abbr gwl "git worktree list "
abbr gs "git switch -c"
abbr gsd "git switch develop"
abbr gcd 'set dir (git worktree list | awk \'{$1=$1; print $3,$1}\' | fzf | awk \'{print $2}\') && test -n "$dir" && cd $dir || echo "exit"'

# edit config file
alias setzsh "vim ~/.zshrc"
alias setbash "vim ~/.bashrc"
alias setfish "cd ~/.config/fish; vim (fd --type file | fzf); cd -"
alias setvim "cd ~/.config/nvim; vim (fd --type file | fzf); cd -"
alias settmux "vim ~/.tmux.conf"
alias setstar "vim $STARSHIP_CONFIG"

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

# vim
abbr vim "nvim"
abbr novim "command nvim -u NONE"

# shell
abbr bash "bash --norc"
abbr zsh "zsh --no-rcs"

abbr tree "exa --tree"

abbr denops-server 'deno run -A --no-check ~/.cache/dein/repos/github.com/vim-denops/denops.vim/denops/@denops-private/cli.ts'

abbr killjava 'killall -9 java'
abbr ntfy 'curl -d "terminal completed!!" ntfy.sh/mikan_terminal_notify'

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
