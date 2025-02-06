" hook_add {{{
nnoremap : <Cmd>call CommandlinePre(':')<CR>:
nnoremap ; <Cmd>call CommandlinePre(':')<CR>:
nnoremap / <Cmd>call CommandlinePre('/')<CR>/

function! CommandlinePre(mode) abort
  " Overwrite sources
  let b:prev_buffer_config = ddc#custom#get_buffer()

  if a:mode ==# ':'
    call ddc#custom#patch_buffer('sourceOptions', #{
          \   _: #{
          \     keywordPattern: '[0-9a-zA-Z_:#-]*',
          \   },
          \ })
    " Use fish source for :! completion
    call ddc#custom#set_context_buffer({ ->
          \ getcmdline()->stridx('!') ==# 0 ? #{
          \   cmdlineSources: [
          \     'shell-native', 'cmdline', 'cmdline_history', 'around',
          \   ],
          \ } : {} })
  " elseif a:mode ==# 'dda'
  "   " For AI completion
  "   call ddc#custom#patch_buffer('cmdlineSources', ['around', 'mocword'])
  endif

  autocmd MikanAutoCmd User DDCCmdlineLeave ++once call CommandlinePost()

  call ddc#enable_cmdline_completion()
endfunction

function! CommandlinePost() abort
  if 'b:prev_buffer_config'->exists()
    call ddc#custom#set_buffer(b:prev_buffer_config)
    unlet b:prev_buffer_config
  endif
endfunction
" }}}

" hook_source {{{
call ddc#custom#load_config('$BASE_DIR/plugins/ddc.ts'->expand())

" For insert mode completion
inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1, 'empty')<CR>
inoremap <C-y> <Cmd>call pum#map#confirm()<CR>
inoremap <C-o> <Cmd>call pum#map#confirm_word()<CR>

inoremap <expr> <TAB>
      \ ddc#ui#inline#visible()
      \ ? ddc#map#insert_item(0)
      \ : pum#visible() 
      \ ? '<Cmd>call pum#map#insert_relative(+1, "empty")<CR>'
      \ : col('.') <= 1 ? '<TAB>' : getline('.')[col('.') - 2] =~# '\s'
      \ ? '<TAB>'
      \ : ddc#map#manual_complete()
inoremap <expr> <C-e> pum#visible()
      \ ? '<Cmd>call pum#map#cancel()<CR>'
      \ : '<End>'
inoremap <expr> <C-l>  ddc#map#manual_complete()

" For command line mode completion
cnoremap <expr> <Tab>
      \ ddc#ui#inline#visible()
      \ ? ddc#map#insert_item(0)
      \ : wildmenumode()
      \ ? &wildcharm->nr2char()
      \ : pum#visible()
      \ ? '<Cmd>call pum#map#insert_relative(+1)<CR>'
      \ : ddc#map#manual_complete()
cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>

call ddc#enable_terminal_completion()
call ddc#enable(#{context_filetype: 'treesitter'})
" }}}
"
" hook_post_update {{{
call ddc#set_static_import_path()
" }}}
