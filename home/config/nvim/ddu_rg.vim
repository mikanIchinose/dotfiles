" set termguicolors

" set runtimepath^=~/.cache/dein/repos/github.com/vim-denops/denops.vim
set runtimepath^=~/.cache/dein/repos/github.com/Shougo/ddu.vim
set runtimepath^=~/.cache/dein/repos/github.com/Shougo/ddu-ui-ff
set runtimepath^=~/.cache/dein/repos/github.com/shun/ddu-source-rg
set runtimepath^=~/.cache/dein/repos/github.com/Shougo/ddu-kind-file

" let g:denops#debug=1

augroup Ddu
 autocmd!
 autocmd FileType ddu-ff nnoremap <buffer> q <Cmd>call ddu#ui#ff#do_action('quit')<CR>
augroup END

call ddu#custom#patch_global(#{
     \ ui: 'ff',
     \ })
