set fish_greeting

# reset abbrs
# __mikan_reset_abbr

source $HOME/.config/fish/aliases.fish
switch (uname)
  case Linux
    source $HOME/.config/fish/aliases_linux.fish
#  set -x PATH "$HOME/Android/Sdk/platform-tools" $PATH
#  set -x JAVA_HOME "/usr/local/android-studio/jre"
#  set -x PATH "$JAVA_HOME/bin" "$PATH"
  case Darwin
    source $HOME/.config/fish/aliases_mac.fish
    set -x PATH "$HOME/Library/Android/sdk/platform-tools" "$HOME/Library/Android/sdk/cmdline-tools/latest/bin" $PATH
    #set -x JAVA_HOME "~/Library/Application Support/JetBrains/Toolbox/apps/AndroidStudio/ch-0/222.4345.14.2221.9321504/Android Studio Preview.app/Contents/jre/Contents/Home/"
    source ~/.asdf/plugins/java/set-java-home.fish
end

if type -q brew &> /dev/null
  set -l HOMEBREW_PREFIX "/opt/homebrew"
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

#if type -q starship &> /dev/null
#  starship init fish | source
#end

if test -d ~/.asdf
  set -l ASDF_HOME "$HOMEBREW_PREFIX/opt/asdf"
  source $ASDF_HOME/libexec/asdf.fish
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

source ~/.config/fish/secrets.fish
