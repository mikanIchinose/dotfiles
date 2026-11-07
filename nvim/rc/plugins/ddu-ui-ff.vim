" ddu-ff {{{
nnoremap <buffer><silent> <CR>
  \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
nnoremap <buffer><silent> <Space>
  \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
nnoremap <buffer><silent> i
  \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
nnoremap <buffer><silent> o
  \ <Cmd>call ddu#ui#do_action('expandItem', #{mode: 'toggle'})<CR>
nnoremap <buffer><silent> p
  \ <Cmd>call ddu#ui#do_action('togglePreview')<CR>
nnoremap <buffer><silent> q
  \ <Cmd>call ddu#ui#do_action('quit')<CR>
nnoremap <buffer><silent> a
  \ <Cmd>call ddu#ui#do_action('chooseAction')<CR>
nnoremap <buffer><silent> d
  \ <Cmd>call ddu#ui#do_action('itemAction',
  \ ddu#ui#get_item()->get('__sourceName', '') ==# 'buffer' ?
  \   #{name: 'deleteBuffers'} : #{name: 'trash'}
  \ )<CR>
nnoremap <buffer><silent> e
  \ <Cmd>call ddu#ui#do_action('itemAction', #{name: 'edit'})<CR>
nnoremap <buffer><silent> \
  \ <Cmd>call ddu#ui#do_action('itemAction',
  \ {'name': 'open', 'params': #{command: 'vertical botright new \| :edit'}})<CR>
nnoremap <buffer><silent> -
  \ <Cmd>call ddu#ui#do_action('itemAction', #{
  \   name: 'open',
  \   params: #{command: 'botright new \| :edit'},
  \ })<CR>
nnoremap <buffer><silent> t
  \ <Cmd>call ddu#ui#do_action('itemAction', #{
  \   name: 'open',
  \   params: #{command: 'tabnew'}
  \ })<CR>
nnoremap <buffer><silent> N
  \ <Cmd>call ddu#ui#do_action('itemAction', #{name: 'new'})<CR>
nnoremap <buffer><silent> r
  \ <Cmd>call ddu#ui#do_action('itemAction', #{name: 'quickfix'})<CR>
" }}}

" ddu-ff-filter {{{
inoremap <buffer><silent> <CR>
  \ <Esc><Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
nnoremap <buffer><silent> <CR>
  \ <Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
nnoremap <buffer><silent> q
  \ <Cmd>call ddu#ui#do_action('quit')<CR>
" }}}
