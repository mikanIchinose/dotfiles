"dein Scripts-----------------------------
if &compatible
  set nocompatible
endif

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#load_toml('~/.config/nvim/dein.toml', {'lazy': 0})
  call map(dein#check_clean(), "delete(v:val, 'rf')")
  call dein#end()
  call dein#save_state()
endif

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
"End dein Scripts-------------------------

filetype plugin indent on
syntax enable
syntax on
" set t_Co=256
set autoindent
set smartindent
set expandtab
set encoding=utf-8
set fileencoding=utf-8
" set fileencodings=iso-2022-jp,euc-jp,utf-8,ucs-2,cp932,sjis
set tabstop=2
set shiftwidth=2
" set cursorline
" set number
" set relativenumber
set showmode
set showmatch
set title
set backspace=indent,eol,start
" set inccommand=split
" set imdisable
" set hidden
set nobackup
set nowritebackup
" set conceallevel=0
hi Comment ctermfg=gray
" if has('mouse')
  " set mouse=a
" endif

" 日本語入力固定モード設定
set runtimepath+=~/.config/nvim/plugins/im_control.vim-master
set statusline+=%{IMStatus('[日本語固定]')}
let IM_CtrlMode = 6
inoremap <silent> <C-j> <C-r>=IMState('FixMode')<CR>
set timeout timeoutlen=3000 ttimeoutlen=100
