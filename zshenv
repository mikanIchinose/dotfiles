export PATH=/opt/homebrew/opt/llvm/bin:"$PATH" # haskellのコンパイルをllvmで実行する
export PATH="$HOME/.local/nvim-macos/bin:$HOME/.local/bin:$HOME/scripts:$HOME/.cargo/bin:$HOME/.deno/bin:$HOME/go/bin:$PATH"

export EDITOR=nvim
export LANG=en_US.UTF-8

# fzf
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

# navi
export NAVI_CONFIG="$HOME/.config/navi/config.yaml"

# lazygit
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"

# starship
export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"
export STARSHIP_CACHE="$HOME/.cache/starship"

# deno
export DENO_INSTALL="$HOME/.deno"

# pnpm
export PNPM_HOME="/Users/solenoid/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

export MOCWORD_DATA=$HOME/mocword.sqlite
