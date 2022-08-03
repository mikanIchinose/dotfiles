let g:loaded_node_provider = v:false
let g:loaded_perl_provider = v:false
let g:loaded_python_provider = v:false
let g:loaded_ruby_provider = v:false

set inccommand=nosplit

set pumblend=20

set winblend=20

" event notifier
" autocmd BufRead * lua vim.notify('BufRead ' .. vim.fn.expand('%'))
" autocmd BufEnter * lua vim.notify('BufEnter ' .. vim.fn.expand('%'))
" autocmd WinEnter * lua vim.notify('WinEnter ' .. vim.fn.winnr())
" autocmd VimEnter * lua vim.notify('VimEnter')
