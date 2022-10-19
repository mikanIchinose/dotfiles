" improve start up time
set runtimepath^=~/ghq/github.com/lewis6991/impatient.nvim
lua require('impatient')

let g:loaded_node_provider       = v:false
let g:loaded_perl_provider       = v:false
let g:loaded_python_provider     = v:false
let g:loaded_ruby_provider       = v:false
let g:loaded_gzip                = 1
let g:loaded_man                 = 1
let g:loaded_zipPlugin           = 1
let g:loaded_tarPlugin           = 1
let g:loaded_matchit             = 1
let g:loaded_2html_plugin        = 1
let g:loaded_tutor_mode_plugin   = 1
let g:loaded_netrwPlugin         = 1
let g:loaded_remote_plugins      = 1
let g:loaded_shada_plugin        = 1
let g:did_install_default_menus  = 1
let g:did_install_syntax_menu    = 1
let g:did_indent_on              = 1
let g:did_load_filetypes         = 1
let g:did_load_ftplugin          = 1

set encoding=utf-8
scriptencoding utf-8

let g:colorscheme='tokyonight'

" dein Scripts {{{
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" download dein.vim
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

" config
let g:dein#auto_recache = v:true
let g:dein#auto_remote_plugins = v:false
let g:dein#lazy_rplugins = v:true
let g:dein#enable_notification = v:true
let g:dein#install_check_diff = v:true
let g:dein#install_progress_type = 'floating'
let g:dein#install_message_type = 'echo'
let g:dein#install_check_remote_threshold = 24 * 60 * 60
let g:dein#install_github_api_token = $DEIN_GITHUB_TOKEN
" let g:dein#install_message_type = 'echo'

" initialize
if dein#min#load_state(s:dein_dir)
  let s:base_dir = fnamemodify(expand('<sfile>'), ':h') . '/'
  let g:dein#inline_vimrcs = ['option.vim', 'neovim.rc.vim']
  call map(g:dein#inline_vimrcs, { _, val -> s:base_dir . val })

  let s:toml_dir  = s:base_dir . 'dein/'
  let s:base_toml = s:toml_dir . 'base.toml'
  let s:lazy_toml = s:toml_dir . 'lazy.toml'
  let s:ddc_toml  = s:toml_dir . 'ddc.toml'
  let s:ddu_toml  = s:toml_dir . 'ddu.toml'
  let s:fern_toml = s:toml_dir . 'fern.toml'
  let s:telescope_toml = s:toml_dir . 'telescope.toml'
  let s:ft_toml   = s:toml_dir . 'ftplugin.toml'

  " dein block {{{
  call dein#begin(s:dein_dir, [
       \ expand('<sfile>'), 
       \ s:base_toml,
       \ s:lazy_toml,
       \ s:ft_toml,
       \ ])

  call dein#load_toml(s:base_toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  call dein#load_toml(s:ddu_toml,  {'lazy': 1})
  call dein#load_toml(s:ddc_toml,  {'lazy': 1})
  call dein#load_toml(s:fern_toml, {'lazy': 1})
  " call dein#load_toml(s:telescope_toml, {'lazy': 1})
  " call dein#load_toml(s:ft_toml)

  call dein#end()
  " dein block end }}}

  call dein#save_state()
  call dein#call_hook('source')
endif

" auto install
if dein#check_install()
  call dein#install()
endif

function! s:dein_toml_syntax() abort
  if expand('%:p') =~# '\vdein/[^/]+.toml$'
    call dein#toml#syntax()
  endif
endfunction
autocmd FileType toml ++nested call timer_start(500, {id -> s:dein_toml_syntax()})

filetype plugin indent on
syntax enable

" }}} End dein Scripts
