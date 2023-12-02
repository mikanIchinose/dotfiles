" hook_add {{{
" command
command! DduFiler :Ddu
      \ -name=file
      \ -resume
      \ -action-option-open2-quit=v:false
      \ -ui=filer
      \ -ui-option-filer-toggle=v:false
      \ -ui-param-filer-split=vertical
      \ -ui-param-filer-splitDirection=topleft
      \ -ui-param-filer-winWidth=30
      \ file
      \ -source-option-file-columns=icon_filename
      \ -source-option-file-path=`getcwd()`
" find file
nnoremap <Leader>ff <Cmd>Ddu
      \ -name=file
      \ -ui-param-ff-floatingTitle=file
      \ file_rec
      \ <CR>
" find buffer
nnoremap <Leader>fb <Cmd>Ddu
      \ -name=buffer
      \ -ui-param-ff-floatingTitle=buffer
      \ buffer
      \ <CR>
" find pattern
nnoremap <Leader>fr <Cmd>Ddu
      \ -name=regex
      \ -ui-param-ff-floatingTitle=regex
      \ rg
      \ -source-param-rg-input=`input('Pattern: ')`
      \ <CR>
" select source
nnoremap <Leader>fs <Cmd>Ddu
      \ -name=source
      \ -ui-param-ff-floatingTitle=source
      \ source
      \ <CR>
nnoremap <Leader>fh <Cmd>Ddu
      \ -name=help
      \ -ui-param-ff-floatingTitle=help
      \ help
      \ <CR>
" insert emoji
inoremap <C-x><C-e> <Cmd>Ddu
      \ -name=emoji
      \ -ui-param-ff-floatingTitle=emoji
      \ emoji
      \ <CR>
" open markdown outline
autocmd FileType markdown
      \ nnoremap <buffer> <Leader>fm <Cmd>Ddu
      \   -name=outline
      \   -resume
      \   -ui=filer
      \   -ui-param-sort=none
      \   -ui-param-sortDirectoriesFirst=v:false
      \   markdown
      \   <CR>
" }}}

" hook_source {{{
call ddu#custom#load_config(expand('$BASE_DIR/plugins/ddu.ts'))
" }}}
