### aliasesのインポート
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

### pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

### pipenv
export PIPENV_VENV_IN_PROJECT=1

# poetry
export PATH="$HOME/.poetry/bin:$PATH"

# deno
export DENO_INSTALL="/home/solenoid/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

### powerline-go
GOPATH=$HOME/go
function powerline_precmd() {
  eval "$($GOPATH/bin/powerline-go -eval -shell zsh -cwd-mode plain -modules time,venv,node,hg,dotenv,exit,cwd,gitlite,newline,git)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}
if [ "$TERM" != "linux" ]; then
  install_powerline_precmd
fi

### fzf
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
#export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

### nvm
export NVM_DIR="$HOME/.nvm"
  [ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && . "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk
zinit light-mode for \
        zdharma/fast-syntax-highlighting \
  zsh-users/zsh-autosuggestions


zinit wait for \
  anonguy/yapipenv.zsh \
  darvid/zsh-poetry \
  atload"zpcdreplay" atclone'./zplug.zsh' \
    g-plane/zsh-yarn-autocompletions \
  djui/alias-tips


### 基本設定
# 補完操作を強くする
autoload -U compinit && compinit -u
zstyle ':completion:*:default' menu select=1
# コマンドの間違いを訂正する
setopt correctall

