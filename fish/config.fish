# reset abbrs
# __mikan_reset_abbr

# alias
source $HOME/.config/fish/aliases.fish
switch (uname)
case Linux
  source $HOME/.config/fish/aliases_linux.fish
case Darwin
  source $HOME/.config/fish/aliases_mac.fish
  # php
  # set -x PATH /opt/homebrew/opt/php@7.4/sbin /opt/homebrew/opt/php@7.4/bin $PATH
end

# dotfilesのシンボリックリンクを環境変数に設定する
# ! 必ずシンボリックリンクを作っておいてください｡でなければコメントアウトしてください
if test -d ~/.dotfiles
  set -x DOTFILES_DIR ~/.dotfiles
end

# starship
if type -q starship
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
if type -q yarn
  set -x PATH $PATH (yarn global bin)
end

# fzf
if type -q fzf
  set -x FZF_LEGACY_KEYBINDINGS 0

  # set -x FZF_DEFAULT_OPTS "--layout=reverse \
  #                          --height=50% \
  #                          --border \
  #                          --ansi \
  #                          --multi \
  #                          --preview='(bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300'"
  # 逆順､半分の高さ､ボーダー付き､ANSIカラー付き
  set -x FZF_DEFAULT_OPTS "--layout=reverse \
                           --height=50% \
                           --border \
                           --ansi"

  # 隠しファイル: 表示
  # 結果に含めないディレクトリ: .git node_modules vendor
  if type -q fd
    set -x FZF_DEFAULT_COMMAND "fd -HI \
                                   --type f \
                                   -E .git \
                                   -E node_modules \
                                   -E vendor"
  end
end

# java
switch (uname)
case Linux
  set -x JAVA_HOME "/usr/local/android-studio/jre"
  set -x PATH "$JAVA_HOME/bin" "$PATH"
case Darwin
  . ~/.asdf/plugins/java/set-java-home.fish
  #set -x JAVA_HOME "/Applications/Android\ Studio.app/Contents/jre/Contents/Home"
  #set -x PATH "$JAVA_HOME/bin" "$PATH"
end

# android studio CLI
switch (uname)
case Linux
  set -x PATH "$HOME/Android/Sdk/platform-tools" $PATH
case Darwin
  set -x PATH "$HOME/Library/Android/sdk/platform-tools" "$HOME/Library/Android/sdk/cmdline-tools/latest/bin" $PATH
end

# flutter
if type -q flutter and test (uname -s) = "Darwin"
  set -x PATH $PATH "$HOME/.local/flutter/bin"
end

# zoxide
if type -q zoxide
  zoxide init fish | source
end

# rust
if type -q cargo
  set -x PATH $HOME/.cargo/bin $PATH
  source "$HOME/.carco/env"
end

# homebrew
if type -q brew
  set -l HOMEBREW_FISH (brew --prefix)"/share/fish"
  set -l HOMEBREW_COMPLETIONS "$HOMEBREW_FISH/completions"
  set -l HOMEBREW_VENDOR_COMPLETIONS "$HOMEBREW_FISH/vendor_completions.d"
  if test -d "$HOMEBREW_COMPLETIONS"
      set -gx fish_complete_path $fish_complete_path "$HOMEBREW_COMPLETIONS"
  end
  if test -d "$HOMEBREW_VENDOR_COMPLETIONS"
      set -gx fish_complete_path $fish_complete_path "$HOMEBREW_VENDOR_COMPLETIONS"
  end
end

# environment variables
switch (uname)
case Linux
case Darwin
  set -x PASSWORD /Volumes/TOSHIBA/password.yml
end
set -x PATH "$HOME/.local/bin" $PATH 
set -x PATH "$HOME/script"     $PATH
set -x GREP_TOOL rg
set -x FIND_TOOL fd
set -x EDITOR nvim
