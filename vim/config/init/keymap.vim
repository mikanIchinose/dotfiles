" " Leader
let mapleader = " "

" move between panes
map <s-h> <C-w>h
map <s-j> <C-w>j
map <s-k> <C-w>k
map <s-l> <C-w>l

" buffer
nnoremap <silent><PageUp> :bprev<CR>
nnoremap <silent><PageDown> :bnext<CR>
"nnoremap <silent><C-w> :bd<CR>

" Map Ctrl + p to open fuzzy find (FZF)
nnoremap <c-p> :Files<cr>
