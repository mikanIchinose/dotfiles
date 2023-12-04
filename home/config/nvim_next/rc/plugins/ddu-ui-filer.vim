" hook_add {{{

" }}}

" hook_source {{{
autocmd MikanAutoCmd TabEnter,WinEnter,CursorHold,FocusGained *
      \ call ddu#ui#do_action('checkItems')
" }}}

" ddu-filer {{{
nnoremap <buffer> q
      \ <Cmd>call ddu#ui#do_action('quit')<CR>
nnoremap <buffer><silent> a
      \ <Cmd>call ddu#ui#ff#do_action('chooseAction')<CR>
nnoremap <buffer> o
      \ <Cmd>call ddu#ui#do_action('expandItem',
      \ #{ mode: 'toggle' })<CR>
nnoremap <buffer> d
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'trash' })<CR>
nnoremap <buffer> m
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'move' })<CR>
nnoremap <buffer> r
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'rename' })<CR>
nnoremap <buffer><silent> v
  \ <Cmd>call ddu#ui#filer#do_action('itemAction',
  \ #{name: 'open', params: #{command: 'vsplit'}})<CR>
nnoremap <buffer> K
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'newDirectory' })<CR>
nnoremap <buffer> N
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ name: 'newFile' })<CR>
nnoremap <buffer> .
      \ <Cmd>call ddu#ui#do_action('updateOptions', #{
      \   sourceOptions: #{
      \     file: #{
      \       matchers: ToggleHidden('file'),
      \     },
      \   },
      \ })<CR>
nnoremap <buffer><expr> <CR>
      \ ddu#ui#get_item()->get('isTree', v:false) ?
      \ "<Cmd>call ddu#ui#do_action('expandItem', #{ mode: 'toggle' })<CR>" :
      \ "<Cmd>call ddu#ui#do_action('itemAction')<CR>"

function! ToggleHidden(name)
  return ddu#custom#get_current(b:ddu_ui_name)
        \ ->get('sourceOptions', {})
        \ ->get(a:name, {})
        \ ->get('matchers', [])
        \ ->empty() ? ['matcher_hidden'] : []
endfunction
" }}}
