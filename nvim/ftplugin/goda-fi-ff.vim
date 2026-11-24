" goda-fi の一覧画面（UI ff）のキーマップ
nnoremap <buffer> <CR>    <Cmd>call goda_fi#ui#do_action('itemAction')<CR>
nnoremap <buffer> i       <Cmd>call goda_fi#ui#do_action('openFilterWindow')<CR>
nnoremap <buffer> q       <Cmd>call goda_fi#ui#do_action('quit')<CR>
nnoremap <buffer> p       <Cmd>call goda_fi#ui#do_action('preview')<CR>
nnoremap <buffer> <Space> <Cmd>call goda_fi#ui#do_action('toggleSelectItem')<CR>
nnoremap <buffer> v       <Cmd>call goda_fi#ui#do_action('itemAction', #{name: 'open', params: #{command: 'vsplit'}})<CR>
