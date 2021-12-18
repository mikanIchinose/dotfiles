set encoding=utf-8
scriptencoding utf-8

"dein Scripts-----------------------------
if &compatible
  set nocompatible
endif

let s:dein_dir      = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

let s:toml_dir  = '~/.config/nvim/dein'
let s:base_toml = s:toml_dir . '/base.mini.toml'
let s:lazy_toml = s:toml_dir . '/lazy.mini.toml'

" config
let g:dein#auto_recache = v:true

" download dein.vim
if &runtimepath !~# '/dein,vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

" initialize
" echo '[dein] initialize'
if dein#min#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [
        \ expand('<sfile>'), s:base_toml, s:lazy_toml
        \ ])

  call dein#load_toml(s:base_toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" auto install
" echo '[dein] check install'
if dein#check_install()
  call dein#install()
endif

" auto remove
" echo '[dein] check remove'
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(dein#check_clean(), "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif

function! DeinFastUpdate()
  if dein#check_install()
    call dein#install()
  endif

  let s:removed_plugins = dein#check_clean()
  if len(s:removed_plugins) > 0
    call map(dein#check_clean(), "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
  endif

  if $DEIN_GITHUB_TOKEN != ""
    let g:dein#install_github_api_token = $DEIN_GITHUB_TOKEN
    call dein#check_update(v:true)
  endif
endfunction

command! DeinFastUpdate call DeinFastUpdate()
"End dein Scripts-------------------------

" ファイル形式検出、形式別プラグイン有効化、形式別インデント有効化
filetype plugin indent on
" 構文ハイライト有効化
syntax enable
