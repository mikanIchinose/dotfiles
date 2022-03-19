typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  /Library/Apple/usr/bin
  # $HOME/.local/bin
  # $HOME/script
  $HOME/Library/Android/sdk/platform-tools
  $HOME/Library/Android/sdk/cmdline-tools/latest/bin
  $HOME/ghq/github.com/flutter/flutter/bin
  # $HOME/.local/flutter/bin
  # $HOME/.cargo/bin
  # $HOME/.deno/bin
)

# php
export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/php@7.4/lib"
export CPPFLAGS="-I/opt/homebrew/opt/php@7.4/include"

if [[ $EMACS == "yes" ]]; then
  ## Emacs経由で起動した場合は環境変数のみ設定する
  . ~/.asdf/plugins/java/set-java-home.zsh
   
  if type starship &> /dev/null; then
    export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"
    export STARSHIP_CACHE="$HOME/.config/starship/cache"
    eval "$(starship init zsh)"
  fi

  ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"
  ASDF_COMPLETIONS="$ASDF_DIR/completions"

  if [[ ! -f "$ASDF_DIR/asdf.sh" || ! -f "$ASDF_COMPLETIONS/asdf.bash" ]] && (( $+commands[brew] )); then
     ASDF_DIR="$(brew --prefix asdf)"
     ASDF_COMPLETIONS="$ASDF_DIR/etc/bash_completion.d"
  fi

  if [[ -f "$ASDF_DIR/asdf.sh" ]]; then
      . "$ASDF_DIR/asdf.sh"
  fi

  if type fzf &> /dev/null; then
   export FZF_COLOR_SCHEME="
   --color=dark
   --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
   --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
   "
   export FZF_LEGACY_KEYBINDINGS=0

   export FZF_DEFAULT_OPTS="
     --layout=reverse
     --height=70%
     --border
     --ansi
     $FZF_COLOR_SCHEME
   "

   if type fd &> /dev/null; then
     export FZF_DEFAULT_COMMAND="
     fd 
       -HI
       --type f
       -E .git
       -E node_modules
       -E vendor
       --exact-depth 2
     "
   fi
  fi

  if type zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
  fi

  if test -d "$HOME/.cargo" &> /dev/null; then
    source "$HOME/.carco/env"
  fi

  if type navi &> /dev/null; then
    export NAVI_CONFIG="$HOME/.config/navi/config.yaml"
  fi

  if test -d "$HOME/.deno" &> /dev/null; then
    if type vr &> /dev/null; then
      source <(vr completions zsh)
    fi
  fi

  # export GREP_TOOL rg
  # export FIND_TOOL fd
  # export EDITOR nvim

  # export PATH="$P"
else
  #[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  type fish &> /dev/null && exec fish
fi

# autoload -Uz compinit
# compinit
# 
# export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
# 
