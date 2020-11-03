# aliasesのインポート
#[[ -f "$HOME/.aliases" ]]; and source "$HOME/.config/fish/.aliases"
#source "$HOME/.config/fish/alias.fish"
set -U fish_user_paths $fish_user_paths /home/solenoid/.php-school/bin

starship init fish | source
#function fish_right_prompt
  #set_color green
  #date "+%H:%M"
  #echo "🎃"
#end
alias t 'tmux' # start session
alias ta 'tmux attach' # attach session
alias tsh 'tmux split-window -h' # split horizontal
alias tsv 'tmux split-window -v' # split vertical
alias tks 'tmux kill-server' # stop tmux server
