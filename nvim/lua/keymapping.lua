local map = vim.keymap.set

-- mouse wheel
map('n', '<ScrollWheelUp>', 'j')
map('n', '<ScrollWheelDown>', 'k')

-- split window
map('n', '<Leader>-', '<Cmd>split<CR>')
map('n', '<Leader>\\', '<Cmd>vsplit<CR>')

map('n', '<Leader>n', '<Cmd>nohlsearch<CR>')

-- better indent
map('n', '<', '<<')
map('n', '>', '>>')

-- better ;
map('n', ';', ':')

map('n', '<Leader>m', '<Cmd>call vimrc#toggle_statusline()<CR>')

map('n', '<Leader>/', '<Cmd>Fern . -reveal=%<CR>', { desc = 'file tree' })

-- map('i', 'jj', '<ESC>')
-- map('i', 'j<Space>', 'j')

map('x', 'r', '<C-v>') -- select rectangle
map('x', 'v', 'V') -- select line
