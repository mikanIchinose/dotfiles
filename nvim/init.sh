#!/bin/bash

# 設定ファイルのシンボリックリンクの作成
echo "create nvim shims to $DOTFILES_DIR"
ln -sf $DOTFILES_DIR/nvim ~/.config/nvim

# install dein.vim
DIR=~/.cache/dein
if [ ! -d $DIR ]; then
	mkdir -p ~/.cache/dein
	cd ~/.cache/dein
	curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
	sh ./installer.sh ~/.cache/dein
	cd -
else
	echo "there is dein dir already"
fi
