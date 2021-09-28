set encoding=utf-8
scriptencoding utf-8

"dein Scripts-----------------------------
if &compatible
  set nocompatible
endif

let s:dein_dir      = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

let s:toml_dir  = '~/.config/nvim/dein'
let s:base_toml = s:toml_dir . '/base.toml'
let s:lazy_toml = s:toml_dir . '/lazy.toml'
let s:ft_toml   = s:toml_dir . '/ftplugin.toml'

" config
" let g:dein#auto_recache = v:true
let g:dein#lazy_rplugins = v:true
let g:dein#install_progress_type = 'title'
let g:dein#enable_notification = v:true

if &runtimepath !~# '/dein,vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [expand('<sfile>'), s:base_toml, s:lazy_toml, s:ft_toml])
  call dein#load_toml(s:base_toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  call dein#load_toml(s:ft_toml)
  " call dein#recache_runtimepath()
  call dein#end()
  call dein#save_state()
endif

" auto installer
if dein#check_install()
  call dein#install()
endif

" auto remover
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(dein#check_clean(), "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
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
" set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileencodings=utf-8
" 改行コードの自動認識
set fileformats=unix,dos,mac
set cursorline
set number
set relativenumber
set showmode
set showmatch
set title
set titlestring=neovim\ %t
set backspace=indent,eol,start
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
" set runtimepath+=~/.config/nvim/plugins/im_control.vim-master
" set statusline+=%{IMStatus('[日本語固定]')}
" let IM_CtrlMode = 6
" inoremap <silent> <C-j> <C-r>=IMState('FixMode')<CR>
set timeout timeoutlen=200 ttimeoutlen=100

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

" eskk.vim
let g:eskk#directory = "~/.config/eskk"
let g:eskk#dictionary = { 'path': "~/.config/eskk/my_jisyo", 'sorted': 1, 'encoding': 'utf-8',}
let g:eskk#large_dictionary = {'path': "~/.config/eskk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp',}
let g:eskk#enable_completion = 0
let g:eskk#egg_like_newline = 1
let g:eskk#marker_henkan = "[変換]"
let g:eskk#marker_henkan_select = "[選択]"
let g:eskk#marker_okuri = "[送り]"
let g:eskk#marker_jisyo_touroku = "[辞書]"
set imdisable
