local smartbuf = require("nvim-smartbufs")
local map = vim.keymap.set
local command = vim.api.nvim_create_user_command

command(
  'CloseCurrentBuffer',
  function(_)
    smartbuf.close_current_buffer()
  end,
  { nargs = 0 }
)

map('n', '<M-Right>', function() smartbuf.goto_next_buffer() end)
map('n', '<M-Left>', function() smartbuf.goto_prev_buffer() end)
