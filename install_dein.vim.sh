#!/bin/bash

# install dein.vim
DIR=~/.cache/dein
if [ ! -d $DIR ]; then
	mkdir -p $DIR
	cd $DIR || exit
	curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
	sh ./installer.sh ~/.cache/dein
	cd - || exit
else
	echo "There has been dein directry already"
fi
