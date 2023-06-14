local map = vim.keymap.set

-- split window
map('n', '<Leader>-', '<Cmd>split<CR>')
map('n', '<Leader>\\', '<Cmd>vsplit<CR>')

-- tab
map('n', '<M-C-Right>', '<Cmd>tabnext<CR>')
map('n', '<M-C-Left>', '<Cmd>tabprevious<CR>')

-- map('n', ';', ':')

-- better indent
map('x', '<', '<<')
map('x', '>', '>>')

-- visual mode
map('x', 'r', '<C-v>')
map('x', 'v', 'V')

-- util
map('n', '<Leader>n', '<Cmd>nohlsearch<CR>')

vim.cmd([[
augroup ftplugin
  autocmd FileType help,null-ls-info,qf nnoremap <buffer> q <Cmd>quit<CR>
augroup END
]])
