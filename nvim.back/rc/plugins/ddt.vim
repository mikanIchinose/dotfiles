" hook_add {{{
"nnoremap <Leader>s <Cmd>call ddt#start(#{
"      \   name: t:->get('ddt_ui_shell_last_name',
"      \                 'shell-' .. win_getid()),
"      \   ui: 'shell',
"      \ })<CR>
nnoremap <Leader>t <Cmd>call ddt#start(#{
      \   name: t:->get('ddt_ui_terminal_last_name',
      \                 'terminal-' .. win_getid()),
      \   ui: 'terminal',
      \ })<CR>
nnoremap sD <Cmd>call ddt#ui#kill_editor()<CR>
nnoremap <C-t> <Cmd>Ddu -name=ddt -sync
      \ -ui-param-ff-split=`has('nvim') ? 'floating' : 'horizontal'`
      \ -ui-param-ff-winRow=1
      \ -ui-param-ff-autoResize
      \ -ui-param-ff-cursorPos=`tabpagenr()`
      \ ddt_tab<CR>
" }}}

" hook_source {{{
call ddt#custom#patch_global(#{
      \   nvimServer: '~/.cache/nvim/server.pipe',
      \   uiParams: #{
      \     terminal: #{
      \       command: ['fish'],
      \       promptPattern: '\w*% \?',
      \     },
      \   },
      \ })

" Set terminal colors
let g:terminal_color_0  = '#6c6c6c'
let g:terminal_color_1  = '#ff6666'
let g:terminal_color_2  = '#66ff66'
let g:terminal_color_3  = '#ffd30a'
let g:terminal_color_4  = '#1e95fd'
let g:terminal_color_5  = '#ff13ff'
let g:terminal_color_6  = '#1bc8c8'
let g:terminal_color_7  = '#c0c0c0'
let g:terminal_color_8  = '#383838'
let g:terminal_color_9  = '#ff4444'
let g:terminal_color_10 = '#44ff44'
let g:terminal_color_11 = '#ffb30a'
let g:terminal_color_12 = '#6699ff'
let g:terminal_color_13 = '#f820ff'
let g:terminal_color_14 = '#4ae2e2'
let g:terminal_color_15 = '#ffffff'

tnoremap <C-t> <Tab>
tnoremap <expr> <Tab>
      \ pum#visible()
      \ ? '<Cmd>call pum#map#select_relative(+1)<CR>'
      \ : '<Tab>'
tnoremap <expr> <S-Tab>
      \   pum#visible()
      \ ? '<Cmd>call pum#map#select_relative(-1)<CR>'
      \ : '<S-Tab>'
"tnoremap <Down>   <Cmd>call pum#map#insert_relative(+1)<CR>
"tnoremap <Up>     <Cmd>call pum#map#insert_relative(-1)<CR>
tnoremap <C-y>    <Cmd>call pum#map#confirm()<CR>
tnoremap <C-o>    <Cmd>call pum#map#confirm()<CR>
" }}}

" ddt-terminal {{{
nnoremap <buffer> <C-n>
      \ <Cmd>call ddt#ui#do_action('nextPrompt')<CR>
nnoremap <buffer> <C-p>
      \ <Cmd>call ddt#ui#do_action('previousPrompt')<CR>
nnoremap <buffer> <C-y>
      \ <Cmd>call ddt#ui#do_action('pastePrompt')<CR>
nnoremap <buffer> <CR>
      \ <Cmd>call ddt#ui#do_action('executeLine')<CR>
nnoremap <buffer> <Leader>gd
      \ <Cmd>call ddt#ui#do_action('send', #{
      \   str: 'git diff',
      \ })<CR>
nnoremap <buffer> <Leader>gc
      \ <Cmd>call ddt#ui#do_action('send', #{
      \   str: 'git commit',
      \ })<CR>
nnoremap <buffer> <Leader>gs
      \ <Cmd>call ddt#ui#do_action('send', #{
      \   str: 'git status',
      \ })<CR>
nnoremap <buffer> <Leader>gA
      \ <Cmd>call ddt#ui#do_action('send', #{
      \   str: 'git commit --amend',
      \ })<CR>
nnoremap <buffer> <Leader>ft <Cmd>Ddu -name=ddt -sync
      \ -input='`ddt#ui#get_input()`'
      \ ddt_shell_history<CR>

augroup ddt-ui-terminal
  autocmd!
  autocmd DirChanged <buffer>
        \ :if t:->get('ddt_ui_last_directory') !=# v:event.cwd
        \ | call ddt#ui#do_action('cd', #{
        \     directory: v:event.cwd,
        \   })
        \ | endif
augroup END

if exists('b:ddt_terminal_directory')
  execute 'tcd' b:ddt_terminal_directory->fnameescape()
endif
" }}}

