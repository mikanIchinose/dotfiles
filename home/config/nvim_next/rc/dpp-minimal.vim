"let $CACHE = '~/.cache'->expand()
"
"function Install(plugin)
"  let dir = $CACHE .. '/dpp/repos/github.com/' .. a:plugin
"  if !(dir->isdirectory())
"    execute '!git clone https://github.com/' .. a:plugin dir
"  endif
"
"  execute 'set runtimepath^='
"        \ .. dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
"endfunction
"
"call Install('Shougo/dpp.vim')
"call Install('Shougo/dpp-ext-lazy')
"
"
"const s:dpp_base = '~/.cache/dpp'->expand()
"let $BASE_DIR = '<sfile>'->expand()->fnamemodify(':h')
"
"if dpp#min#load_state(s:dpp_base)
"  call Install('Shougo/dpp-ext-installer')
"  call Install('Shougo/dpp-ext-local')
"  call Install('Shougo/dpp-ext-toml')
"  call Install('Shougo/dpp-protocol-git')
"  call Install('vim-denops/denops.vim')
"  runtime! plugin/denops.vim
"  autocmd User DenopsReady
"        \ call dpp#make_state(s:dpp_base, '$BASE_DIR/dpp-minimal.ts'->expand())
"endif

let $CACHE = '~/.cache'->expand()
function Install(plugin)
  let dir = $CACHE .. '/dpp/repos/github.com/' .. a:plugin
  if !(dir->isdirectory())
    execute '!git clone https://github.com/' .. a:plugin dir
  endif

  execute 'set runtimepath^='
        \ .. dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endfunction
"call Install('Shougo/dpp.vim')
"call Install('Shougo/dpp-ext-lazy')
"call Install('Shougo/dpp-ext-installer')
"call Install('Shougo/dpp-ext-local')
"call Install('Shougo/dpp-ext-toml')
"call Install('Shougo/dpp-protocol-git')
"call Install('vim-denops/denops.vim')

set runtimepath^=~/.cache/dpp/repos/github.com/Shougo/dpp.vim
set runtimepath^=~/.cache/dpp/repos/github.com/Shougo/dpp-ext-lazy
set runtimepath^=~/.cache/dpp/repos/github.com/Shougo/dpp-ext-toml
set runtimepath^=~/.cache/dpp/repos/github.com/vim-denops/denops.vim
runtime! plugin/denops.vim
const s:dpp_base = '~/.cache/dpp'->expand()
if dpp#min#load_state(s:dpp_base)
  autocmd User DenopsReady
        \ call dpp#make_state(s:dpp_base, '$BASE_DIR/dpp-minimal.ts'->expand())
endif
