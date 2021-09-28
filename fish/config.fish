# set abbrs
__mikan_reset_abbr
source $HOME/.config/fish/aliases.fish

switch (uname)
case Linux
  source $HOME/.config/fish/aliases_linux.fish
case Darwin
  source $HOME/.config/fish/aliases_mac.fish
  # php
  set -x PATH /opt/homebrew/opt/php@7.4/sbin /opt/homebrew/opt/php@7.4/bin $PATH

  set -x PASSWORD /Volumes/TOSHIBA/password.yml
end

# dotfilesのシンボリックリンクを環境変数に設定する
# 注意: 必ずシンボリックリンクを作っておいてください｡でなければコメントアウトしてください
if test -d ~/.dotfiles
  set -x DOTFILES_DIR ~/.dotfiles
end

# nvimで使ったりする
set -x XDG_CONFIG_HOME "$HOME/.config"

set -x PATH $PATH "$HOME/.local/bin"

# starship
if type -q starship
  starship init fish | source
  set -x STARSHIP_CONFIG "$HOME/.starship/config.toml"
  set -x STARSHIP_CACHE "$HOME/.starship/cache"
end

# asdf
if test -d ~/.asdf
  source ~/.asdf/asdf.fish
end

# yarn path
# if type -q yarn
#   set -x PATH $PATH (yarn global bin)
# end

# fzf
# if type -q fzf
#   set -x FZF_LEGACY_KEYBINDINGS 0
#   ## 逆順､半分の高さ､ボーダー付き､ANSIカラー付き
#   # set -x FZF_DEFAULT_OPTS "--layout=reverse --height=50% --border --ansi --multi --preview='(bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300'"
#   set -x FZF_DEFAULT_OPTS "--layout=reverse --height=50% --border --ansi"
#   # 隠しファイル: 表示
#   # 結果に含めないディレクトリ: .git node_modules vendor
#   set -x FZF_DEFAULT_COMMAND "fd -HI --type f -E .git -E node_modules -E vendor"
# end

set -x JAVA_HOME "/usr/local/android-studio/jre"
set -x PATH "$JAVA_HOME/bin" "$PATH"

# android studio CLI
switch (uname)
case Linux
  set -x PATH "$HOME/Android/Sdk/platform-tools" $PATH
case Darwin
  set -x PATH "$HOME/Library/Android/sdk/platform-tools" "$HOME/Library/Android/sdk/cmdline-tools/latest/bin" $PATH
end

# flutter
if test (uname -s) = "Darwin"
  set -x PATH $PATH "$HOME/.local/flutter/bin"
end

# zoxide
if type -q zoxide
  zoxide init fish | source
end

# rust
# if test -d $HOME/.cargo
#   set -x PATH $HOME/.cargo/bin $PATH
#   source "$HOME/.carco/env"
# end

# homebrew
if test -d (brew --prefix)"/share/fish/completions"
    set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
end
if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

# environment variables
set -x GREP_TOOL rg
set -x FIND_TOOL fd
