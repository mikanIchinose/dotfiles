" " Leader
let mapleader = " "

" move between panes
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" buffer
nnoremap <silent><PageUp> :bprev<CR>
nnoremap <silent><PageDown> :bnext<CR>
nnoremap <silent><C-w> :bd<CR>

" Map Ctrl + p to open fuzzy find (FZF)
nnoremap <c-p> :Files<cr>
