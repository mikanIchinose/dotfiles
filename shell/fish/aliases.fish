## global
### シェルの再起動
alias reload "exec fish"
### パッケージの更新
abbr update "sudo apt update && sudo apt upgrade -y; brew upgrade; fisher update"
### サスペンド
abbr suspend "systemctl suspend"

## apt
abbr ainst "sudo apt install -y"
abbr arm "sudo apt remove"
alias auninst "arm"
abbr aauto "sudo apt autoremove"

## ls
alias ls "exa -a"
alias lh "clear && exa -al"
abbr cl "clear"

## change owner to me
abbr chown "sudo chown -R $USER:$USER ."

## git
### gitリポジトリに移動 
# alias gcd "cd (ghq root)/(ghq list | fzf)"
### IMDと名の付くリポジトリに移動
# alias imd "cd (ghq root)/(ghq list | rg IMD | fzf)"
abbr g "git"
# abbr gcheck "git checkout (git branch | fzf | sed 's/^ *\| *\$//')"
abbr gb "git branch"
abbr gad "git add"
abbr gc "git commit"
abbr gs "git stash -u"
abbr gpo "git stash pop"
abbr gap "git stash apply"
abbr gm "git merge"
abbr gfo "git fetch origin"

## edit config file
alias setzsh "vim ~/.zshrc"
alias setfish "cd ~/.config/fish; vim config.fish; cd -"
alias setvim "vim (fd ~/.config/nvim | fzf --reverse)"
alias settmux "vim ~/.tmux.conf"

## tmux
# alias t "tmux" # start session
# alias ta "tmux attach" # attach session
# alias tsh "tmux split-window -h" # split horizontal
# alias tsv "tmux split-window -v" # split vertical
# alias tks "tmux kill-server" # stop tmux server

## docker
abbr d "docker"
alias dps "docker container ls --format \"table {{.Names}}\t{{.Ports}}\""
# docker-compose
abbr dc "docker-compose"
abbr dup "docker-compose up -d"
abbr dd "docker-compose down"
abbr dk "docker-compose down --rmi all --volumes --remove-orphans"
alias dreload "ddown && dup"
abbr dex "docker-compose exec"
abbr dr "docker-compose run"
abbr db "docker-compose build"

## emacs
# alias e="emacsclient -a """
# alias ekill="emacsclient -e "(kill-emacs)""

## vim
alias vim "nvim"

## bash
alias bash "bash --norc"

## tree
alias tree "tree -N"
