
# if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
#     print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
#     command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
#     command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
#         print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
#         print -P "%F{160}▓▒░ The clone has failed.%f%b"
# fi

# source "$HOME/.zinit/bin/zinit.zsh"
# autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

#zinit light-mode for \
  #agkozak/zsh-z

#zinit wait light-mode for \
  #zsh-users/zsh-completions \
  #zsh-users/zsh-autosuggestions \
  #anonguy/yapipenv.zsh \
  #darvid/zsh-poetry \
  #atload"zpcdreplay" atclone'./zplug.zsh' \
    #g-plane/zsh-yarn-autocompletions \
  #djui/alias-tips

# aliasの設定
# [[ -f "$HOME/dotfiles/shell/.aliases" ]] && source "$HOME/dotfiles/shell/.aliases"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# pipenv
# ルートに.venvディレクトリを作る
export PIPENV_VENV_IN_PROJECT=1

# poetry
export PATH=$HOME/.poetry/bin:$PATH

# deno
export DENO_INSTALL="/home/solenoid/.deno"
export PATH=$DENO_INSTALL/bin:$PATH

# yarn
export PATH=$PATH:`yarn global bin`

# starship shell prompt
#eval "$(starship init zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

# excerism
# binフォルダのパスを通す
export PATH=~/bin:$PATH
# 補完に関するスクリプトの読み込み
export fpath=(~/.zsh/functions $fpath)

# rust and cargo
export PATH=$PATH:$HOME/.cargo/bin

# X server
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export LIBGL_ALWAYS_INDIRECT=1

# emacs
export PATH=$HOME/.local/bin:$PATH

# chrome
export PATH="/mnt/c/Program Files (x86)/Google/Chrome/Application:$PATH"
export BROWSER=chrome.exe

# composer
export PATH="$PATH:$HOME/.composer/vendor/bin"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/solenoid/.sdkman"
[[ -s "/home/solenoid/.sdkman/bin/sdkman-init.sh" ]] && source "/home/solenoid/.sdkman/bin/sdkman-init.sh"

# java from sdkman
export JAVA_HOME=$HOME/.sdkman/candidates/java/current
export PATH=$JAVA_HOME/bin:$PATH

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
# 基本設定
# 補完を強くする
# autoload -U compinit && compinit -u
# zstyle ':completion:*:default' menu select=1
# コマンドの間違いを訂正する
# setopt correctall
exec fish

