local map = vim.keymap.set

-- split window
map('n', '<Leader>-', '<Cmd>split<CR>')
map('n', '<Leader>\\', '<Cmd>vsplit<CR>')

map('n', '<Leader>n', '<Cmd>nohlsearch<CR>')

-- better indent
map('n', '<', '<<')
map('n', '>', '>>')

map('x', 'r', '<C-v>') -- select rectangle
map('x', 'v', 'V') -- select line

vim.cmd([[
augroup ftplugin
  autocmd FileType null-ls-info,help nnoremap <buffer> q <Cmd>quit<CR>
augroup END
]])
