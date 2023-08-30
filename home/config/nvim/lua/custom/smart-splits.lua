local smart_splits = require('smart-splits')
local map = vim.keymap.set

map('n', '<Leader>R', smart_splits.start_resize_mode, { desc = 'resize mode' })
map('n', '<C-h>', smart_splits.move_cursor_left)
map('n', '<C-j>', smart_splits.move_cursor_down)
map('n', '<C-k>', smart_splits.move_cursor_up)
map('n', '<C-l>', smart_splits.move_cursor_right)
