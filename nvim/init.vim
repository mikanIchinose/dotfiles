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


" ファイル形式検出、形式別プラグイン有効化、形式別インデント有効化
filetype plugin indent on
" 構文ハイライト有効化
syntax enable
"syntax on
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
" インデント数
set shiftwidth=2
" 空白文字の可視化
set list listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%,space:·
set encoding=utf-8
" set fileencoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
" 改行コードの自動認識
set fileformats=unix,dos,mac
set cursorline
set number
set relativenumber
set showmode
set showmatch
set title
set backspace=indent,eol,start
" インクリメンタル文字列置換
set inccommand=split
" ファイル未保存状態でも別のファイルを開けるようにする
set hidden
set nowritebackup
" クリップボード連携
" prerequirement: brew install xclip
set clipboard+=unnamedplus
" コメントの色をグレーにする
hi Comment ctermfg=gray

" leaderをspaceに変更
let g:mapleader = "\<Space>"
let g:maplocalleader = ","

" 日本語入力固定モード設定
set runtimepath+=~/.config/nvim/plugins/im_control.vim-master
set statusline+=%{IMStatus('[日本語固定]')}
let IM_CtrlMode = 6
" inoremap <silent> <C-j> <C-r>=IMState('FixMode')<CR>
set timeout timeoutlen=300 ttimeoutlen=100

" mac用のIME無効化
if has('mac')
  let g:imeoff = 'osascript -e "tell application \"System Events\" to key code 102"'
  augroup MyIMEGroup
    autocmd!
    autocmd! InsertLeave * :call system(g:imeoff) | exe ":w"
  augroup END
endif

set background=dark
colorscheme gruvbox

