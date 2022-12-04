# reset abbrs
# __mikan_reset_abbr

# fish_vi_key_bindings
# set fish_cusor_default block
# set fish_cusor_insert line
# set fish_cusor_replace_one underscore
# set fish_cusor_visual block

#switch (uname)
#case Linux
#  source $HOME/.config/fish/aliases_linux.fish
#  set -x PATH "$HOME/Android/Sdk/platform-tools" $PATH
#  set -x JAVA_HOME "/usr/local/android-studio/jre"
#  set -x PATH "$JAVA_HOME/bin" "$PATH"
#case Darwin
 source $HOME/.config/fish/aliases_mac.fish
 set -x PATH "$HOME/Library/Android/sdk/platform-tools" "$HOME/Library/Android/sdk/cmdline-tools/latest/bin" $PATH
# . ~/.asdf/plugins/java/set-java-home.fish
#end

# Android Studio
set -x JAVA_HOME "~/Library/Application Support/JetBrains/Toolbox/apps/AndroidStudio/ch-0/222.4345.14.2221.9321504/Android Studio Preview.app/Contents/jre/Contents/Home/"
# . ~/.asdf/plugins/java/set-java-home.fish

source $HOME/.config/fish/aliases.fish
set -l HOMEBREW_PREFIX "/opt/homebrew"

if type -q brew &> /dev/null
  set -l HOMEBREW_FISH "$HOMEBREW_PREFIX/share/fish"
  set -l HOMEBREW_COMPLETIONS "$HOMEBREW_FISH/completions"
  set -l HOMEBREW_VENDOR_COMPLETIONS "$HOMEBREW_FISH/vendor_completions.d"
  if test -d "$HOMEBREW_COMPLETIONS" &> /dev/null
    set -gx fish_complete_path $fish_complete_path "$HOMEBREW_COMPLETIONS"
  end
  if test -d "$HOMEBREW_VENDOR_COMPLETIONS" &> /dev/null
      set -gx fish_complete_path $fish_complete_path "$HOMEBREW_VENDOR_COMPLETIONS"
  end
end

if type -q starship &> /dev/null
  starship init fish | source
end

if test -d ~/.asdf
  set -l ASDF_HOME "$HOMEBREW_PREFIX/opt/asdf"
  source $ASDF_HOME/libexec/asdf.fish
end

# if type -q fzf &> /dev/null
#   set -l FZF_COLOR_SCHEME "
#   --color=dark
#   --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
#   --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
#   "
#   set -x FZF_LEGACY_KEYBINDINGS 0
#
#   # 逆順､半分の高さ､ボーダー付き､ANSIカラー付き
#   set -x FZF_DEFAULT_OPTS "
#     --layout=reverse
#     --height=50%
#     --border
#     --ansi
#     $FZF_COLOR_SCHEME
#   "
#
#   if type -q fd &> /dev/null
#     set -x FZF_DEFAULT_COMMAND "
#     fd
#       -HI
#       --type f
#       -E .git
#       -E node_modules
#       -E vendor
#       --exact-depth 2
#     "
#   end
# end

if type -q flutter &> /dev/null
  set -x PATH $PATH "$HOME/.local/flutter/bin"
end

if type -q zoxide &> /dev/null
  zoxide init fish | source
end

# if test -d "$HOME/.cargo" &> /dev/null
#   set -x PATH $HOME/.cargo/bin $PATH
#   source "$HOME/.cargo/env"
# end

# navi: An interactive cheatsheet tool for the command-line
# homepage: https://github.com/denisidoro/navi
if type -q navi &> /dev/null
  set -x NAVI_CONFIG "$HOME/.config/navi/config.yaml"

  #NOTE: バグがないかたまに確認しよう
  #NOTE: https://github.com/denisidoro/navi/issues?q=is%3Aissue+is%3Aopen+shell+widget
  function _navi_smart_replace
    set -l current_process (commandline -p | string trim)

    if test -z "$current_process"
      commandline -i (navi --print)
    else
      set -l best_match (navi --print --best-match --query "$current_process")

      if not test "$best_match" >/dev/null
        return
      end

      if test -z "$best_match"
        commandline -p (navi --print --query "$current_process")
      else if test "$current_process" != "$best_match"
        commandline -p $best_match
      else
        commandline -p (navi --print --query "$current_process")
      end
    end

    commandline -f repaint
  end

  # C-n: start navi
  if test $fish_key_bindings = fish_default_key_bindings
    bind \cn _navi_smart_replace
  else
    bind -M insert \cn _navi_smart_replace
  end
end

if test -d "$HOME/.deno" &> /dev/null
  set -x DENO_INSTALL "$HOME/.deno"
  set -x PATH "$DENO_INSTALL/bin" $PATH
end

set -x PATH "$HOME/.local/bin" $PATH
set -x PATH "$HOME/scripts"     $PATH
set -x GREP_TOOL rg
set -x FIND_TOOL fd
set -gx EDITOR nvim

set -x LG_CONFIG_FILE "$HOME/.config/lazygit/config.yml"

source $HOME/.config/fish/secrets.fish

set fish_greeting
