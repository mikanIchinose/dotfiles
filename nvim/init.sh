# 設定ファイルのシンボリックリンクの作成
ln -sf ~/dotfiles/nvim/init.vim ~/.config/nvim

# install dein.vim
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.config/nvim/dein
