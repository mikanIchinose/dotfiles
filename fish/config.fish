# set -U fish_user_paths $fish_user_paths /home/solenoid/.php-school/bin

# VcXsrv
# set -x DISPLAY '(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')':0
# set -x LIBGL_ALWAYS_INDIRECT 1

# dotfilesのシンボリックリンクを環境変数に設定する
# 注意: 必ずシンボリックリンクを作っておいてください｡でなければコメントアウトしてください
set -x DOTFILES_DIR ~/.dotfiles
set -x XDG_CONFIG_HOME "$HOME/.config"

# appimageをコマンドラインから使えるようにパスを通す
set -x PATH $HOME/AppImage $PATH

# starship
# official site: https://starship.rs
starship init fish | source

# asdf
source ~/.asdf/asdf.fish
# yarn path
set -x PATH $PATH (yarn global bin)

# fzf
set -x FZF_LEGACY_KEYBINDINGS 0
## 逆順､半分の高さ､ボーダー付き､ANSIカラー付き
set -x FZF_DEFAULT_OPTS "--layout=reverse --height 50% --border --ansi"

# alias

## global
### シェルの再起動
alias reload 'exec fish'
### パッケージの更新
alias update 'sudo apt update && sudo apt upgrade -y'

## apt
alias ainst 'sudo apt install -y'
alias arm 'sudo apt remove'
alias auninst 'arm'
alias aauto 'sudo apt autoremove'

## ls
alias ls 'ls --color=auto -F'
alias lh 'clear && ls -lh'
alias cl 'clear'

## change owner
alias change-owner 'sudo chown -R $USER:$USER .'

## git
### gitリポジトリに移動 
alias gcd 'cd (ghq root)/(ghq list | fzf )'
### IMDと名の付くリポジトリに移動
alias imd 'cd (ghq root)/(ghq list | rg IMD | fzf )'
alias g 'git'
alias gbranch 'git branch'
alias gadd 'git add'
alias gcommit 'git commit'
alias gcheck 'git checkout'
alias gstash 'git stash -u'
alias gpop 'git stash pop'
alias gapply 'git stash apply'
alias gmerge 'git merge'
alias gpush 'git push'
alias gpull 'git pull'

## edit config file
alias setzsh 'nvim ~/.zshrc'
alias setfish 'nvim ~/.config/fish/config.fish'
alias setvim 'nvim (find ~/.config/nvim/ | fzf --reverse)'
alias settmux 'nvim ~/.tmux.conf'

## tmux
# alias t 'tmux' # start session
# alias ta 'tmux attach' # attach session
# alias tsh 'tmux split-window -h' # split horizontal
# alias tsv 'tmux split-window -v' # split vertical
# alias tks 'tmux kill-server' # stop tmux server

## docker
alias d 'docker'
# docker-compose
alias dc 'docker-compose'
alias dup 'docker-compose up -d'
alias ddown 'docker-compose down'
alias dreload 'ddown && dup'
alias dexec 'docker-compose exec'
alias drun 'docker-compose run'
alias dbuild 'docker-compose build'
alias dps 'docker container ls --format "table {{.Names}}\t{{.Ports}}"'

## emacs
# alias e='emacsclient -a ""'
# alias ekill='emacsclient -e "(kill-emacs)"'

## vim
alias vim='nvim'

## bash
alias bash "bash --norc"
