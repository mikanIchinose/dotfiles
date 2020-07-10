" vim起動時にNERDTreeを立ち上げる
" autocmd VimEnter * execute 'NERDTree'
" NERDTreeだけになったらvimを閉じる
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" keymap
nnoremap <silent><C-n> :NERDTree<CR>
" show dot file
let NERDTreeShowHidden=1
