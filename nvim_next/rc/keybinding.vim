" navigation at insert-mode
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
" navigation at command-mode
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>
" navigation at terminal-mode
tnoremap <ESC> <C-\><C-n>

" easy save
nnoremap <Leader><Leader> <Cmd>silent update<CR><Cmd>set cmdheight=0<CR>

inoremap <expr> ; vimrc#sticky_func()

" easy escape
inoremap jj <ESC>
inoremap j<Space> j
