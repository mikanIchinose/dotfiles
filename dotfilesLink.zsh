function link() {
  ln -sf ~/dotfiles/$1 ~/$1
}
link .aliases
link .zshrc
link .bashrc
link .gitconfig
link .vimrc
link .jupyter

