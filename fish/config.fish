# set -U fish_user_paths $fish_user_paths /home/solenoid/.php-school/bin

# VcXsrv
# set -x DISPLAY '(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')':0
# set -x LIBGL_ALWAYS_INDIRECT 1


# starship
# official site: https://starship.rs
starship init fish | source

# rbenv
# status --is-interactive; and rbenv init - | source

# asdf
source ~/.asdf/asdf.fish

# fzf
set -U FZF_LEGACY_KEYBINDINGS 0
set -U FZF_REVERSE_ISEARCH_OPTS "--reverse --height=100%"

# alias setting
alias reload 'exec fish'
alias update 'sudo apt update && sudo apt upgrade -y'
# ls
alias ls 'ls --color=auto -F'
alias lh 'clear &&ls -lh'
alias cl 'clear'
# git
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
# setting
alias setzsh 'vim ~/.zshrc'
alias setfish 'vim ~/.config/fish/config.fish'
alias setvim 'vim ~/dotfiles/vim'
alias settmux 'vim ~/.tmux.conf'
# apt
alias ainst 'sudo apt install'
alias arm 'sudo apt remove'
# tmux
# alias t 'tmux' # start session
# alias ta 'tmux attach' # attach session
# alias tsh 'tmux split-window -h' # split horizontal
# alias tsv 'tmux split-window -v' # split vertical
# alias tks 'tmux kill-server' # stop tmux server
# docker
# docker-compose
alias dup 'docker-compose up -d'
alias ddown 'docker-compose down'
alias dexec 'docker-compose exec'
# emacs
alias e='emacsclient -a ""'
alias ekill='emacsclient -e "(kill-emacs)"'

alias bash="bash --norc"
alias g='cd (ghq root)/(ghq list | fzf)'
# alias gh='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'
