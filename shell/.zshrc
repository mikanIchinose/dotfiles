# typeset -U path PATH
# path=(
  # /opt/homebrew/bin(N-/)
  # /opt/homebrew/sbin(N-/)
  # /usr/bin
  # /usr/sbin
  # /bin
  # /sbin
  # /usr/local/bin(N-/)
  # /usr/local/sbin(N-/)
  # /Library/Apple/usr/bin
  # $HOME/script
  # $HOME/Library/Android/sdk/platform-tools
  # $HOME/Library/Android/sdk/cmdline-tools/latest/bin
  # $HOME/ghq/github.com/flutter/flutter/bin
  # $HOME/.local/flutter/bin
# )

if type starship &> /dev/null; then
  export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"
  export STARSHIP_CACHE="$HOME/.config/starship/cache"
fi

if type zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

if test -d "$HOME/.cargo" &> /dev/null; then
  source "$HOME/.cargo/env"
fi

if test -d "$HOME/.deno" &> /dev/null; then
  if type vr &> /dev/null; then
    source <(vr completions zsh)
  fi
fi

if [[ $EMACS == "yes" ]]; then
  ## Emacs経由で起動した場合は環境変数のみ設定する
  # . ~/.asdf/plugins/java/set-java-home.zsh
   
  ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"
  ASDF_COMPLETIONS="$ASDF_DIR/completions"

  if [[ ! -f "$ASDF_DIR/asdf.sh" || ! -f "$ASDF_COMPLETIONS/asdf.bash" ]] && (( $+commands[brew] )); then
     ASDF_DIR="$(brew --prefix asdf)"
     ASDF_COMPLETIONS="$ASDF_DIR/etc/bash_completion.d"
  fi

  if [[ -f "$ASDF_DIR/asdf.sh" ]]; then
      . "$ASDF_DIR/asdf.sh"
  fi
else
  type fish &> /dev/null && exec fish
fi
