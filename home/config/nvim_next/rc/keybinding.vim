" navigation at insert-mode
inoremap <M-h> <Left>
inoremap <M-j> <Down>
inoremap <M-k> <Up>
inoremap <M-l> <Right>
" navigation at command-mode
cnoremap <M-h> <Left>
cnoremap <M-j> <Down>
cnoremap <M-k> <Up>
cnoremap <M-l> <Right>
" navigation at terminal-mode
tnoremap <ESC> <C-\><C-n>

" easy save
nnoremap <Leader><Leader> <Cmd>silent update<CR><Cmd>set cmdheight=0<CR>

inoremap <expr> ; vimrc#sticky_func()

" easy escape
inoremap jj <ESC>
inoremap j<Space> j

" tab navigation
"nnoremap <Leader>tn <Cmd>tabnext<CR>
"nnoremap <Leader>tp <Cmd>tabprevious<CR>
