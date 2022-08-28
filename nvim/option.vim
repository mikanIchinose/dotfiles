filetype plugin indent on
syntax enable

" indent & tab/space
" 直前の行と同じインデントを挿入する
set autoindent
" ブロックに応じてインデントを自動挿入する
set smartindent
" tabキーでインデント挿入する
set smarttab
" tabをスペースで挿入する
set expandtab
" タブ幅
set tabstop=2
set softtabstop=2
" インデント数
set shiftwidth=2

" set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set enc=utf-8
set fenc=utf-8
set fileencodings=utf-8
" 改行コードの自動認識
set fileformats=unix,dos,mac
lang en_US.UTF-8

" ui
set cursorline
" set cursorcolumn
set signcolumn=yes
" set showmode
set showmatch
set title
set titlestring=%t
set backspace=indent,eol,start
set inccommand=split
" try
"   set cmdheight=0
" catch
"   set cmdheight=1
" endtry
set cmdheight=1
set laststatus=3
set nowrap
" fold
set foldmethod=marker

" ファイル未保存状態でも別のファイルを開けるようにする
set hidden
set nowritebackup
" クリップボード連携
" NOTE: prerequirement: xclip
set clipboard+=unnamedplus

" leaderをspaceに変更
let g:mapleader = "\<Space>"
let g:maplocalleader = ","

set timeout timeoutlen=100 ttimeoutlen=200

" completion
set completeopt=menuone
" if exists('+completepopup')
"   set completeopt+=popup
"   set completepopup=height:4,width:60,highlight:InfoPopup
" endif
" Don't complete from other buffer.
set complete=.
" Set popup menu max height.
set pumheight=30
if exists('+pumwidth')
  " Set popup menu min width.
  set pumwidth=0
endif
" Use "/" for path completion
set completeslash=slash

" color
set termguicolors
set background=dark
execute 'colorscheme ' .. g:colorscheme

" neovimからデフォルトでマウスモードがONになったので落す
set mouse=

set guifont=FiraCode\ Nerd\ Font:h12

set winblend=0 " floating window の透明度を無くす
set helplang=ja
