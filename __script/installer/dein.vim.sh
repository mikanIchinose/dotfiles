#!/bin/bash

echo -e "\n--------- dein.vim ---------\n"
DEIN_VIM_DIR=~/.cache/dein
if [ ! -d $DEIN_VIM_DIR ]; then
	mkdir -p $DEIN_VIM_DIR
	cd $DEIN_VIM_DIR || exit
	curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
	sh ./installer.sh ~/.cache/dein
  rm -i installer.sh
	cd - || exit
else
	echo -e "\nThere has been dein directry already\n"
fi
