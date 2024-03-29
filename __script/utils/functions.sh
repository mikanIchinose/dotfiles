#! /usr/bin/env bash

########################################
# シンボリックリンクの作成
# Arguments:
#   file_name: String
#   link_name: String
########################################
symlink() {
  ORVERWRITTEN=""
  if [ -e "$2" ] || [ -h "$2" ]; then
    ORVERWRITTEN="(Orverwritten)"
    # 既存のリンクを削除
    if ! rm -r "$2"; then
      substep_error "Failed to remove existing file(s) at $2."
    fi
  fi
  if ln -s "$1" "$2"; then
    substep_success "Symlinked $2 to $1. $ORVERWRITTEN"
  else
    substep_error "Symlinking $2 to $1 failed."
  fi
}

########################################
# シンボリックリンクの削除
# Arguments:
#   link_name: String
########################################
clear_broken_symlinks() {
  find -L "$1" -type l | while read -r fn; do
    if rm "$fn"; then
      substep_success "Removed broken symlink at $fn."
    else
      substep_error "Failed to remove broken symlink at $fn."
    fi
  done
}

########################################
# Arguments:
#   expression: String
#   color: String
#   prefix: String
########################################
coloredEcho() {
  local exp="$1"
  local color="$2";
  local prefix="$3";
  if ! [[ $color =~ ^[0-9]$ ]] ; then
     case $(echo "$color" | tr '[:upper:]' '[:lower:]') in
      black) color=0 ;;
      red) color=1 ;;
      green) color=2 ;;
      yellow) color=3 ;;
      blue) color=4 ;;
      magenta) color=5 ;;
      cyan) color=6 ;;
      white|*) color=7 ;;
     esac
  fi
  tput bold;
  tput setaf "$color";
  echo "$prefix $exp";
  tput sgr0;
}

info() {
  coloredEcho "$1" blue "========>"
}

success() {
  coloredEcho "$1" green "========>"
}

error() {
  coloredEcho "$1" red "========>"
}

substep_info() {
  coloredEcho "$1" magenta "===="
}

substep_success() {
  coloredEcho "$1" cyan "===="
}

substep_error() {
  coloredEcho "$1" red "===="
}
