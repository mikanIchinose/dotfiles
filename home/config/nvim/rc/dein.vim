let $CACHE = '~/.cache'->expand()
if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif

" install step
let s:plugin = 'Shougo/dein.vim'
let s:dir = $CACHE .. '/dein/repos/github.com/' .. s:plugin
if !(s:dir->isdirectory())
  execute '!git clone https://github.com/' .. s:plugin s:dir
endif
execute 'set runtimepath^=' .. s:dir->fnamemodify(':p')->substitute('[/\\]$','','')

" configuration step
let g:dein#auto_recache = v:true
let g:dein#auto_remote_plugins = v:false
let g:dein#enable_notification = v:true
let g:dein#install_check_diff = v:true
let g:dein#install_check_remote_threshold = 24 * 60 * 60
let g:dein#install_progress_type = 'floating'
let g:dein#lazy_rplugins = v:true
let g:dein#types#git#enable_partial_clone = v:true
let g:dein#install_github_api_token = $DEIN_GITHUB_TOKEN

" リポジトリの展開位置を指定
" ~/.cache/dein/repos/github.com/{USER_NAME}/{REPO}という形式で展開されるようにする
let s:path = $CACHE .. '/dein'
let g:dein_load_state = !dein#min#load_state(s:path)
if g:dein_load_state
  finish
endif

let g:dein#inline_vimrcs = [
      \ '$BASE_DIR/keybinding.vim'
      \ ]

" plugin step
call dein#begin(s:path, ['<sfile>'->expand()])

call dein#load_toml('$BASE_DIR/dein.toml',   #{ lazy: 0 })
call dein#load_toml('$BASE_DIR/lazy.toml',   #{ lazy: 1 })
call dein#load_toml('$BASE_DIR/denops.toml', #{ lazy: 1 })
call dein#load_toml('$BASE_DIR/ddc.toml',    #{ lazy: 1 })
call dein#load_toml('$BASE_DIR/ddu.toml',    #{ lazy: 1 })

call dein#end()
call dein#save_state()

filetype indent plugin on

" Enable syntax highlighting
if has('syntax')
  syntax on
endif
