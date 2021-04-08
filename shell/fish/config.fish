# 外部ファイルの読み込み
reset_abbr
source $HOME/.config/fish/aliases.fish

# dotfilesのシンボリックリンクを環境変数に設定する
# 注意: 必ずシンボリックリンクを作っておいてください｡でなければコメントアウトしてください
set -x DOTFILES_DIR ~/.dotfiles

set -x XDG_CONFIG_HOME "$HOME/.config"

# starship
# official site: https://starship.rs
if type -q starship
  starship init fish | source
end

# asdf
if test -d ~/.asdf
  source ~/.asdf/asdf.fish
end

# yarn path
if type -q yarn
  set -x PATH $PATH (yarn global bin)
end

# fzf
set -x FZF_LEGACY_KEYBINDINGS 0
## 逆順､半分の高さ､ボーダー付き､ANSIカラー付き
set -x FZF_DEFAULT_OPTS "--layout=reverse --height=50% --border --ansi --multi --preview='(bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300'"
set -x FZF_DEFAULT_COMMAND "fd -HI --type f -E .git -E node_module -E vendor"
