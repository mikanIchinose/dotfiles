# reset abbrs
# __mikan_reset_abbr

switch (uname)
case Linux
  source $HOME/.config/fish/aliases_linux.fish
  set -x PATH "$HOME/Android/Sdk/platform-tools" $PATH
  set -x JAVA_HOME "/usr/local/android-studio/jre"
  set -x PATH "$JAVA_HOME/bin" "$PATH"
case Darwin
  source $HOME/.config/fish/aliases_mac.fish
  set -x PASSWORD /Volumes/TOSHIBA/password.yml
  set -x PATH "$HOME/Library/Android/sdk/platform-tools" "$HOME/Library/Android/sdk/cmdline-tools/latest/bin" $PATH
  . ~/.asdf/plugins/java/set-java-home.fish
end

# alias
source $HOME/.config/fish/aliases.fish

# starship
if type -q starship &> /dev/null
  starship init fish | source
  set -x STARSHIP_CONFIG "$HOME/.config/starship/config.toml"
  set -x STARSHIP_CACHE  "$HOME/.config/starship/cache"
end

# asdf
if test -d ~/.asdf
  #source ~/.asdf/asdf.fish
  source (brew --prefix asdf)/libexec/asdf.fish
end

# yarn path
# if type -q yarn
#   set -x PATH $PATH (yarn global bin)
# end

# fzf
if type -q fzf &> /dev/null
  set -l FZF_COLOR_SCHEME "
  --color=dark
  --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
  --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
  "
  set -x FZF_LEGACY_KEYBINDINGS 0

# 逆順､半分の高さ､ボーダー付き､ANSIカラー付き
  set -x FZF_DEFAULT_OPTS "
    --layout=reverse
    --height=50%
    --border
    --ansi
    $FZF_COLOR_SCHEME
  "

  if type -q fd &> /dev/null
    set -x FZF_DEFAULT_COMMAND "
    fd 
      -HI
      --type f
      -E .git
      -E node_modules
      -E vendor
      --exact-depth 2
    "
  end
end

# flutter
if type -q flutter and test (uname -s) = "Darwin" &> /dev/null
  set -x PATH $PATH "$HOME/.local/flutter/bin"
end

# zoxide
if type -q zoxide &> /dev/null
  zoxide init fish | source
end

# rust
if test -d "$HOME/.cargo" &> /dev/null
  set -x PATH $HOME/.cargo/bin $PATH
  source "$HOME/.carco/env"
end

# homebrew
if type -q brew &> /dev/null
  set -l HOMEBREW_FISH (brew --prefix)"/share/fish"
  set -l HOMEBREW_COMPLETIONS "$HOMEBREW_FISH/completions"
  set -l HOMEBREW_VENDOR_COMPLETIONS "$HOMEBREW_FISH/vendor_completions.d"
  if test -d "$HOMEBREW_COMPLETIONS"
      set -gx fish_complete_path $fish_complete_path "$HOMEBREW_COMPLETIONS"
  end
  if test -d "$HOMEBREW_VENDOR_COMPLETIONS" &> /dev/null
      set -gx fish_complete_path $fish_complete_path "$HOMEBREW_VENDOR_COMPLETIONS"
  end
end

# navi
if type -q navi &> /dev/null
  navi widget fish | source
  set -x NAVI_CONFIG "$HOME/.config/navi/config.yaml"
end

# deno
if test -d "$HOME/.deno" &> /dev/null
  set -x DENO_INSTALL "$HOME/.deno"
  set -x PATH "$DENO_INSTALL/bin" $PATH
  if type -q vr &> /dev/null
    source (vr completions fish | psub)
  end
end

set -x PATH "$HOME/.local/bin" $PATH 
set -x PATH "$HOME/script"     $PATH
set -x GREP_TOOL rg
set -x FIND_TOOL fd
set -x EDITOR nvim
set fish_greeting
