# update package
alias update 'sudo apt update && sudo apt upgrade -y'

# ls
alias ls 'ls --color=auto -F'
alias lh 'clear && ls -lh'

# cd
alias .. 'cd ..'
alias ..2 'cd ../..'
alias ..3 'cd ../../..'
alias ~ 'cd ~'

# clear
alias cl 'clear'

# git
# alias log_in_bbc 'ssh -T git@bitbucket.org'
alias g 'git'
# branch
alias gb 'git branch'
alias gbv 'git branch --verbose'
alias gbx 'git branch -d'
# index
alias gia 'git add'
# commit
alias gc 'git commit'
alias gcm 'git commit -m'
alias gco 'git checkout'
# merge
alias gm 'git merge'
# push
alias gp 'git push'
# tag
alias gt 'git tag'

# setting
alias setzsh 'vim ~/.zshrc'
alias setvim 'cd ~/.vim && vim .'
alias settmux 'vim ~/.tmux.conf'

# apt
alias agi 'sudo apt install'
alias agr 'sudo apt remove'

# cp mv rm for safety
alias cp 'cp -i'
alias mv 'mv -i'
alias rm 'rm -i'

# zsh
alias reload 'exec fish'

# homebrew
# alias binst 'brew install'
# alias buninst 'brew uninstall'
# alias bup 'brew update && brew upgrade'

# poetry
alias pydev 'poetry add -D flake8 autopep8 pylint mypy'

# tmux
alias t 'tmux' # start session
alias ta 'tmux attach' # attach session
alias tsh 'tmux split-window -h' # split horizontal
alias tsv 'tmux split-window -v' # split vertical
alias tks 'tmux kill-server' # stop tmux server
#alias ide 'zsh ~/.tmux/session/ide'