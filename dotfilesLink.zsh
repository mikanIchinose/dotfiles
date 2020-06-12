function link() {
  ln -sf ~/dotfiles/$1 ~/$1
}
link .aliases
link .zshrc
link .bashrc
link .gitconfig
link .jupyter
link .vim
ln -sf ~/dotfiles/.vim/.vimrc ~/.vimrc
