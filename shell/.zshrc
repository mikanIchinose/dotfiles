# if [ -f "$HOME/.local/share/zap/zap.zsh" ]; then
#   source "$HOME/.local/share/zap/zap.zsh"
#   plug "zsh-users/zsh-autosuggestions"
#   # plug "zsh-users/zsh-syntax-highlighting"
#   plug "zdharma-continuum/fast-syntax-highlighting"
#   typeset -A __Prompt
#   __Prompt[ITALIC_ON]=$'\e[3m'
#   __Prompt[ITALIC_OFF]=$'\e[23m'
#   plug "zap-zsh/singularisart-prompt"
#   plug "olets/zsh-abbr"
#   abbr -e gst="git status"
#   abbr gst="git status -sb"
#   abbr g "git"
#   abbr gb "git branch --merged"
#   abbr ga "git add "
#   abbr gc "git commit -m "
#   abbr gs "git stash "
#   abbr gsp "git stash pop "
#   abbr gsa "git stash apply "
#   abbr gsd "git stash drop "
#   abbr gps "git push"
#   abbr gpl "git pull"
#   abbr gplr "git pull --rebase origin develop"
#   abbr grc "git rebase --continue"
#   abbr gm "git merge"
#   abbr gf "git fetch origin"
#   abbr gw "git worktree "
#   abbr gwr "git worktree remove "
#   abbr gwl "git worktree list "
#   abbr gsw "git switch -c "
# fi

[ -f "$HOME/.secrets.sh" ] && source "$HOME/.secrets.sh"

[ -f "/Users/solenoid/.ghcup/env" ] && source "/Users/solenoid/.ghcup/env"

WITHOUT_FISH=

if [[ $WITHOUT_FISH == "yes" ]]; then
  ## Emacs経由で起動した場合のみ
  if type starship &> /dev/null; then
    # eval "$(starship init zsh)"
  fi

  if type zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
  fi

  if test -d "$HOME/.cargo" &> /dev/null; then
    source "$HOME/.cargo/env"
  fi

  if test -d "$HOME/.deno" &> /dev/null; then
  fi

  if [[ -d "$HOME/.asdf" ]]; then
    source "$(brew --prefix asdf)/libexec/asdf.sh"
    source "$(brew --prefix asdf)/completions/asdf.bash"
  fi
  autoload -Uz compinit && compinit -C
else
  type fish &> /dev/null && exec fish
fi

