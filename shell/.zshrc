export PATH=/opt/homebrew/opt/llvm/bin:"$PATH" # haskellのコンパイルをllvmで実行する
export PATH=/usr/local/smlnj/bin:"$PATH"
export PATH="$HOME/.local/nvim-macos/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.deno/bin:$HOME/go/bin:$PATH"
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
export FZF_DEFAULT_COMMAND="
fd 
  -HI
  --type f
  -E .git
  -E node_modules
  -E vendor
  --exact-depth 2
"
export NAVI_CONFIG="$HOME/.config/navi/config.yaml"

[ -f "/Users/solenoid/.ghcup/env" ] && source "/Users/solenoid/.ghcup/env" # ghcup-env

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

# . ~/.asdf/plugins/java/set-java-home.zsh

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
