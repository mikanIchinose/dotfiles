"let g:airline_theme = 'gruvbox'
let g:airline_theme = 'papercolor'
set t_Co=256 
set laststatus=2
let g:airline_powerline_fonts = 1

" extention setting
" vim-fugitive
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#use_vcscommand = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#wordcount#enabled = 1
" coc.nvim
let g:airline#extensions#coc#enabled = 1

let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'y', 'z']]
let g:airline_section_c = '%t'
let g:airline_section_x = '%{&filetype}'
let g:airline_section_z = '%3l:%2v %{airline#extensions#ale#get_warning()} %{airline#extensions#ale#get_error()}'

let g:airline_mode_map = {
  \ 'n'  : 'N',
  \ 'i'  : 'I',
  \ 'R'  : 'R',
  \ 'c'  : 'C',
  \ 'v'  : 'V',
  \ 'V'  : 'VL',
  \ '' : 'VB',
  \ }

" symbol
let g:airline_left_sep = "\ue0b4"
let g:airline_right_sep = "\ue0b2"

if !exists("g:airline_symbols")
  let g:airline_symbols = {}
endif

let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'
