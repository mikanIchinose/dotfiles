syntax on
set t_Co=256

set autoindent
set smartindent
set expandtab
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,utf-8,ucs-2,cp932,sjis
set tabstop=2
set shiftwidth=2
set cursorline
set number
set relativenumber
set showmode
set showmatch
set title
set backspace=indent,eol,start
set inccommand=split
set imdisable
set hidden
set nobackup
set nowritebackup
set conceallevel=0

hi Comment ctermfg=gray

if has('mouse')
  set mouse=a
endif

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif
set runtimepath+=~/.config/nvim/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('~/.config/nvim/dein')
  call dein#begin('~/.config/nvim/dein')

  call dein#load_toml('~/.config/nvim/dein.toml', {'lazy': 0})

  call dein#end()
  call dein#save_state()
endif
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
"End dein Scripts-------------------------
