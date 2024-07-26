" hook_add {{{
nnoremap <Leader>s
      \ <Cmd>call deol#start(#{
      \   command: 'zsh',
      \   start_insert: v:false,
      \   edit_filetype: 'fish',
      \ })<CR>
nnoremap <Leader>S
      \ <Cmd>call deol#start(#{
      \   command: 'zsh',
      \   start_insert: v:false,
      \   edit_filetype: 'fish',
      \   split: 'floating',
      \ })<CR>
nnoremap <C-t>
      \ <Cmd>Ddu
      \ -name=deol
      \ -sync
      \ -ui-param-ff-split=floating
      \ -ui-param-ff-winRow=1
      \ -ui-param-ff-autoResize
      \ -ui-param-ff-cursorPos=`tabpagenr()-1`
      \ deol<CR>
" }}}
" hook_source {{{
let g:deol#enable_dir_changed = v:false
let g:deol#prompt_pattern = '\w*% ❯'
call ddu#custom#patch_global(#{
      \   sourceParams: #{
      \     deol: #{command: ['fish']}
      \   }
      \ })
tnoremap <C-t> <Tab>
"tnoremap <expr> <Tab>
"      \ pum#visible() ?
"      \   '<Cmd>call pum#map#select_relative(+1)<CR>' :
"      \   '<Tab>'
"tnoremap <expr> <S-Tab>
"      \ pum#visible() ?
"      \   '<Cmd>call pum#map#select_relative(-1)<CR>' :
"      \   '<S-Tab>'
"tnoremap <Down> <Cmd>call pum#map#insert_relative(+1)<CR>
"tnoremap <Up>   <Cmd>call pum#map#insert_relative(-1)<CR>
"tnoremap <C-y>  <Cmd>call pum#map#confirm()<CR>
"tnoremap <C-o>  <Cmd>call pum#map#confirm()<CR>
" }}}
" deol {{{
nnoremap <buffer> <C-n>  <Plug>(deol_next_prompt)
nnoremap <buffer> <C-p>  <Plug>(deol_previous_prompt)
nnoremap <buffer> <CR>   <Plug>(deol_execute_line)
nnoremap <buffer> A      <Plug>(deol_start_append_last)
nnoremap <buffer> I      <Plug>(deol_start_insert_first)
nnoremap <buffer> a      <Plug>(deol_start_append)
nnoremap <buffer> e      <Plug>(deol_edit)
nnoremap <buffer> i      <Plug>(deol_start_insert)
nnoremap <buffer> q      <Plug>(deol_quit)
" }}}
" fish {{{
" }}}
