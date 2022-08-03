set encoding=utf-8
scriptencoding utf-8

"dein Scripts-----------------------------
if &compatible
  set nocompatible
endif

" config
let g:dein#auto_recache = v:true
let g:dein#lazy_rplugins = v:true
let g:dein#enable_notification = v:true
let g:dein#install_check_diff = v:true
let g:dein#install_progress_type = 'title'
let g:dein#install_message_type = 'none'

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

let s:toml_dir  = '~/.config/nvim/dein'
let s:base_toml = s:toml_dir . '/base.toml'
let s:lazy_toml = s:toml_dir . '/lazy.toml'
let s:ft_toml   = s:toml_dir . '/ftplugin.toml'
let s:ddu_toml  = s:toml_dir . '/ddu.toml'
let s:ddc_toml  = s:toml_dir . '/ddc.toml'
let s:fern_toml = s:toml_dir . '/fern.toml'
let s:telescope_toml = s:toml_dir . '/telescope.toml'

" download dein.vim
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

" initialize
if dein#min#load_state(s:dein_dir)
  let s:base_dir = fnamemodify(expand('<sfile>'), ':h') . '/'
  let g:dein#inline_vimrcs = ['option.vim', 'neovim.rc.vim']
  call map(g:dein#inline_vimrcs, {_, val -> s:base_dir . val})

  call dein#begin(s:dein_dir, [
        \ expand('<sfile>'), 
        \ s:base_toml,
        \ s:lazy_toml,
        \ s:ft_toml,
        \ s:fern_toml,
        \ s:telescope_toml,
        \ ])

  call dein#load_toml(s:base_toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  call dein#load_toml(s:ddu_toml,  {'lazy': 1})
  call dein#load_toml(s:ddc_toml,  {'lazy': 1})
  call dein#load_toml(s:fern_toml, {'lazy': 1})
  call dein#load_toml(s:telescope_toml, {'lazy': 1})
  " call dein#load_toml(s:ft_toml)

  call dein#end()

  call dein#call_hook('source')
  call dein#save_state()
  " call dein#recache_runtimepath()
endif

" auto install
if dein#check_install()
  call dein#install()
endif

" auto remove
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(dein#check_clean(), "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif

" fast update command using github graphq api
" function! DeinFastUpdate() abort
"   let g:dein#install_github_api_token = $DEIN_GITHUB_TOKEN
"   call dein#check_update(v:true)
"   " echo 'update done'
" endfunction
" command! DeinFastUpdate call DeinFastUpdate()
"End dein Scripts-------------------------

"user settings---------------------------
" Brewfile treat as ruby-file
augroup brewfile
  autocmd BufRead Brewfile set filetype=ruby
augroup END

" ddc-gitmoji
" let g:denops#debug = 1
" set runtimepath^=~/ghq/github.com/mikanIchinose/ddc-gitmoji
" set runtimepath^=~/LocalProject/ddc-deno-import-map
"
command! ToggleStatusLine call vimrc#toggle_statusline()
"End user settings---------------------------

lua << EOF
require('impatient')
vim.notify = require("notify")
require("keymapping")
require("custom.which-key")
EOF
