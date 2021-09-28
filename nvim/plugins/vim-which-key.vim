" quickrunで開いたバッファをすぐに閉じる
nnoremap <Space>o :only<CR>

let g:mapleader = "\<Space>"
let g:maplocalleader = ','
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

let g:which_key_use_floating_win = 1

let g:which_key_map = {}

let g:which_key_map.f = {
  \ 'name': 'find something',
  \ 'f': ['Files', 'file'],
  \ 'r': ['Rg', 'code'],
  \ 'b': ['Buffers', 'buffer'],
  \ }

let g:which_key_map.w = ['update', 'save current buffer']
let g:which_key_map.W = ['wall', 'save all buffers']
let g:which_key_map.q = ['quit', 'close current buffer']
let g:which_key_map.Q = ['qall', 'close all buffers']
let g:which_key_map['-'] = ['split', 'split horizontally']
let g:which_key_map['|'] = ['vsplit', 'split vertically']
let g:which_key_map.c = {
  \ 'name': '+coc',
  \ 'a': ['<Plug>(coc-codeaction)', 'code action'],
  \ 'q': ['<Plug>(coc-fix-current)', 'quick fix'],
  \ 'g': {
    \ 'name': '+go',
    \ 'd': ['<Plug>(coc-definition)', 'definition'],
    \ 'y': ['<Plug>(coc-type-definition)', 'type definition'],
    \ 'i': ['<Plug>(coc-implementation)', 'implementation'],
    \ 'r': ['<Plug>(coc-references)', 'references'],
    \ },
  \ 'r': ['<Plug>(coc-rename)', 'rename'],
  \ }

call which_key#register('<Space>', "g:which_key_map")
