# aliasの設定
# [[ -f "$HOME/dotfiles/shell/.aliases" ]] && source "$HOME/dotfiles/shell/.aliases"

# starship shell prompt
# eval "$(starship init zsh)"

# fzf
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
# export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

# excerism
# binフォルダのパスを通す
# export PATH=~/bin:$PATH
# 補完に関するスクリプトの読み込み
# export fpath=(~/.zsh/functions $fpath)
#
# flutter
export PATH="$PATH:$HOME/ghq/github.com/flutter/flutter/bin"
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"

# 基本設定
# 補完を強くする
autoload -U compinit && compinit -u
zstyle ':completion:*:default' menu select=1
# コマンドの間違いを訂正する
setopt correctall

# start fish
type fish &> /dev/null && exec fish
# exec fish

