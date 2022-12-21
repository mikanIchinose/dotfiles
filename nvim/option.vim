
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
set autoindent smartindent

" set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
" 改行コードの自動認識
set fileformats=unix,dos,mac
lang en_US.UTF-8

"NOTE: buffer
set cursorline
" set cursorcolumn
set signcolumn=yes
" set showmode
set showmatch
set title
set titlestring=%t
set backspace=indent,eol,start
set inccommand=split
"NOTE: statusline
try
  set cmdheight=0
  autocmd MyAutoCmd RecordingEnter * set cmdheight=1
  autocmd MyAutoCmd RecordingLeave * set cmdheight=0
catch
  set cmdheight=1
endtry
set laststatus=3
set nowrap
" fold
set foldmethod=expr

" ファイル未保存状態でも別のファイルを開けるようにする
set hidden
set nowritebackup
" クリップボード連携
set clipboard+=unnamedplus

" leaderをspaceに変更
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
set timeout timeoutlen=100 ttimeoutlen=200
set updatetime=200

" NOTE: completion
set completeopt=menuone
" Don't complete from other buffer.
set complete=.
" Set popup menu max height.
set pumheight=10
if exists('+pumwidth')
  " Set popup menu min width.
  set pumwidth=0
endif
" Use "/" for path completion
set completeslash=slash

" color
set termguicolors
set background=dark
colorscheme dracula

set noequalalways

" disable mouse
set mouse=

set guifont=FiraCode\ Nerd\ Font:h12

set winblend=0 " floating window の透明度を無くす
" set helplang=ja

set inccommand=nosplit
" set pumblend=20
" set winblend=20

" set isfname&
" \ isfname+=@-@
" \ isfname-==
" set isfname-==

set textwidth=0
set wrapmargin=0

" Search
set ignorecase
set smartcase
set incsearch
set nohlsearch
set wrapscan

set directory-=.
set undofile
let &g:undodir = &directory

set listchars=tab:▸\ ,trail:-,precedes:«,nbsp:%

set noshowcmd
set noruler

set splitkeep=screen
