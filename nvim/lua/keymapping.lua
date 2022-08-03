local smartbuf = require("nvim-smartbufs")
local mapping = {
  i = {
    { 'jj', '<ESC>', 'easy escape' },
    { 'j<Space>', 'j', 'insert j' },
  },
  n = {
    -- switch buffer
    { 'sh', '<C-w>h', 'left buffer' },
    { 'sj', '<C-w>j', 'down buffer' },
    { 'sk', '<C-w>k', 'up buffer' },
    { 'sl', '<C-w>l', 'right buffer' },
    -- tree viewer
    { '<Leader>/', '<Cmd>Fern . <CR>', 'file tree' },
    -- indent
    { '>', '>>', '' },
    { '<', '<<', '' },
    -- better x
    { 'x', '_x', 'better x' },
    -- buffer
    { '<M-Right>', function() smartbuf.goto_next_buffer() end, '' },
    { '<M-Left>', function() smartbuf.goto_prev_buffer() end, '' },
    { '<Leader>qq', function() smartbuf.close_current_buffer() end, '' },
    { '<Leader>qa', function() smartbuf.close_all() end, '' },
    -- toggle statusline
    { '<Leader>m', '<Cmd>call vimrc#toggle_statusline()<CR>', '' }
  },
  v = {
  },
  x = {
    { 'r', '<C-v>', 'select rectangle' },
  },
}

-- nomal-mode
for _, table in pairs(mapping.n) do
  vim.keymap.set("n", table[1], table[2], { desc = table[3] })
end

-- visual-mode
for _, table in pairs(mapping.v) do
  vim.keymap.set("v", table[1], table[2], { desc = table[3] })
end

for _, table in pairs(mapping.i) do
  vim.keymap.set("i", table[1], table[2], { desc = table[3] })
end

for _, table in pairs(mapping.x) do
  vim.keymap.set("x", table[1], table[2], { desc = table[3] })
end
