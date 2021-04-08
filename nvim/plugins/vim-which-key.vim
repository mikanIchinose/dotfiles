set timeoutlen=500
let g:mapleader="\<Space>"
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :WhichKey ','<CR>
let g:which_key_use_floating_win = 1
let g:which_key_map = {}
let g:which_key_map.f = {
  \ 'name': '+fzf',
  \ 'f': ['FZF', 'open file with fzf']
  \ }

call which_key#register('<Space>', "g:which_key_map")
