local smartbuf = require('nvim-smartbufs')
local map = vim.keymap.set

vim.api.nvim_create_user_command('CloseCurrentBuffer', function(_)
  smartbuf.close_current_buffer()
end, { nargs = 0 })

map('n', '<M-Right>', smartbuf.goto_next_buffer)
map('n', '<M-Left>', smartbuf.goto_prev_buffer)
