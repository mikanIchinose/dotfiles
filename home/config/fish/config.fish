#set fish_greeting

# source ~/.secret/.secrets.fish
source $HOME/.config/fish/aliases.fish

function backup
  backup_ghq
  backup_go
  backup_cargo
  backup_fisher
  backup_gh_extension
end

function backup_go -d "backup globally installed go tool"
  gup list | awk -F'@' '{print $1}' | awk '{print $2 "@latest"}' > ~/dotfiles/gofile
end

function backup_cargo -d "backup globally installed rust tool"
  ls ~/.cargo/bin/ > ~/dotfiles/cargofile
end

function backup_ghq -d "backup ghq repositories"
  ghq list > ~/local/.ghqfile
end

function import_ghq -d "import ghq repositories from ghqfile"
  cat ~/local/.ghqfile | ghq get --parallel --update
end

function backup_fisher
  fisher list > ~/dotfiles/fishfile
end

function backup_gh_extension
  gh extension list | awk '{print $3}' > ~/dotfiles/ghfile
end

switch (uname)
  case Linux
    source $HOME/.config/fish/aliases_linux.fish
    # set -x PATH "$HOME/Android/Sdk/platform-tools" $PATH
    # set -x JAVA_HOME "/usr/local/android-studio/jre"
    # set -x PATH "$JAVA_HOME/bin" "$PATH"
  case Darwin
    source $HOME/.config/fish/aliases_mac.fish
    set -x JAVA_HOME "$HOME/Applications/Android Studio.app/Contents/jbr/Contents/Home"
    # set -x PATH "$HOME/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin" $PATH
    set -x ANDROID_HOME "$HOME/Library/Android/sdk"
    set -x PATH \
      "$ANDROID_HOME/platform-tools" \
      "$ANDROID_HOME/emulator" \
      "$ANDROID_HOME/cmdline-tools/latest/bin" \
      # バージョンは変わりうる
      "$ANDROID_HOME/build-tools/34.0.0" \
      $PATH
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

set -x PATH $HOME/.cache/dpp/repos/github.com/liquidz/vim-iced/bin $PATH

#if type -q starship &> /dev/null
#  starship init fish | source
#end

# if type -q asdf
#   set -l ASDF_HOME "$HOMEBREW_PREFIX/opt/asdf"
#   source $ASDF_HOME/libexec/asdf.fish
# end

if type -q zoxide &> /dev/null
  zoxide init fish | source
end
if type -q starship &> /dev/null
  starship init fish | source
end

# navi: An interactive cheatsheet tool for the command-line
# homepage: https://github.com/denisidoro/navi
if type -q navi &> /dev/null
  # NOTE: バグがないかたまに確認しよう
  # NOTE: https://github.com/denisidoro/navi/issues?q=is%3Aissue+is%3Aopen+shell+widget
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

# source ~/.config/fish/completions/cargo-make.fish
