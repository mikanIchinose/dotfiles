" create ~/.cache if needed
let $CACHE = '~/.cache'->expand()
if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif

function Install(plugin)
  let dir = $CACHE .. '/dpp/repos/github.com/' .. a:plugin
  if !(dir->isdirectory())
    execute '!git clone https://github.com/' .. a:plugin dir
  endif

  execute 'set runtimepath^='
        \ .. dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endfunction

" install step
call Install('Shougo/dpp.vim')
call Install('Shougo/dpp-ext-lazy')

" configuration step
"let g:denops#debug = 1
"let g:denops_server_addr = '127.0.0.1:32123'

const s:dpp_base = '~/.cache/dpp'->expand()

let $BASE_DIR = '<sfile>'->expand()->fnamemodify(':h')

" load state file or recreate state
if dpp#min#load_state(s:dpp_base)
  call Install('Shougo/dpp-ext-installer')
  call Install('Shougo/dpp-ext-local')
  call Install('Shougo/dpp-ext-toml')
  call Install('Shougo/dpp-protocol-git')
  call Install('vim-denops/denops.vim')
  runtime! plugin/denops.vim

  " call dpp#make_state after DenopsReady because it depends denops.vim
  autocmd MikanAutoCmd User DenopsReady
        \ echohl WarningMsg 
        \ | echomsg 'dpp load_state() is failed'
        \ | echohl NONE
        \ | call dpp#make_state(s:dpp_base, '$BASE_DIR/plugins/dpp.ts'->expand())
else
  autocmd MikanAutoCmd BufWritePost *.lua,*.vim,*.toml,*.ts
        \ call dpp#check_files()
endif

autocmd MikanAutoCmd User Dpp:makeStatePost
      \ echohl WarningMsg
      \ | echomsg 'dpp make_state() is done'
      \ | echohl NONE

filetype plugin indent on
