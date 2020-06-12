set nocompatible
set runtimepath+=~/dotfiles/.vim/bundle/repos/github.com/Shougo/dein.vim

if dein#load_state('~/dotfiles/.vim/bundle')
  call dein#begin('~/dotfiles/.vim/bundle')

  let s:toml_dir = '~/dotfiles/.vim'
  let s:toml = s:toml_dir . '/dein.toml'
  " let s:lazy_toml = s:toml_dir . '/dein_lazy.toml'
  
  " tomlの読み込み
  call dein#load_toml(s:toml,      {'lazy': 0})
  " call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax on

" インストールされていないプラグインのチェック
if dein#check_install()
  call dein#install()
endif

" アンインストールしたプラグインのチェック
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins)>0
  call map(s:removed_plugins,"delete(v:val,'rf')")
  call dein#recache_runtimepath()
endif

" editor setting
source ~/.vim/config/init/editor.vim
" plugin setting
source ~/.vim/config/plugins/rainbow_parentheses.vim
source ~/.vim/config/plugins/nerdtree.vim
source ~/.vim/config/plugins/ale.vim
source ~/.vim/config/plugins/airline.vim
