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
" set number
" set relativenumber
set signcolumn=yes:2
set showmode
set showmatch
set title
set titlestring=%t
set backspace=indent,eol,start
set inccommand=split
" ファイル未保存状態でも別のファイルを開けるようにする
set hidden
set nowritebackup
" クリップボード連携
" prerequirement: xclip
set clipboard+=unnamedplus
" コメントの色をグレーにする
hi Comment ctermfg=gray
set cmdheight=2

" leaderをspaceに変更
let g:mapleader = "\<Space>"
let g:maplocalleader = ","

" 日本語入力固定モード設定
" set runtimepath+=~/.config/nvim/plugins/im_control.vim-master
" set statusline+=%{IMStatus('[日本語固定]')}
" let IM_CtrlMode = 6
" inoremap <silent> <C-j> <C-r>=IMState('FixMode')<CR>
set timeout timeoutlen=200 ttimeoutlen=100

"let g:did_install_default_menus = 1
"let g:did_install_syntax_menu   = 1
"let g:did_indent_on             = 1
"let g:did_load_filetypes        = 1
"let g:did_load_ftplugin         = 1
"let g:loaded_2html_plugin       = 1
"let g:loaded_gzip               = 1
"let g:loaded_man                = 1
"let g:loaded_matchit            = 1
"let g:loaded_matchparen         = 1
"let g:loaded_netrwPlugin        = 1
"let g:loaded_remote_plugins     = 1
"let g:loaded_shada_plugin       = 1
"let g:loaded_spellfile_plugin   = 1
"let g:loaded_tarPlugin          = 1
"let g:loaded_tutor_mode_plugin  = 1
"let g:loaded_zipPlugin          = 1
"let g:skip_loading_mswin        = 1

inoremap <silent><expr><bs> 
  \ (&indentexpr isnot '' ? &indentkeys : &cinkeys) =~? '!\^F' &&
  \ &backspace =~? '.*eol\&.*start\&.*indent\&' &&
  \ !search('\S','nbW',line('.')) ? (col('.') != 1 ? "\<C-U>" : "") .
  \ "\<bs>" . (getline(line('.')-1) =~ '\S' ? "" : "\<C-F>") : "\<bs>"
