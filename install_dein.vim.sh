#!/bin/bash

# install dein.vim
DIR=~/.cache/dein
if [ ! -d $DIR ]; then
	mkdir -p ~/.cache/dein
	cd ~/.cache/dein
	curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
	sh ./installer.sh ~/.cache/dein
	cd -
else
	echo "there has been dein dir already"
fi
