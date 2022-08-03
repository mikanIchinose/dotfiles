local smartbuf = require("nvim-smartbufs")

vim.keymap.set('n', '<M-Right>', smartbuf.goto_next_buffer)
vim.keymap.set('n', '<M-Left>', smartbuf.goto_prev_buffer)
vim.keymap.set('n', '<Leader>qq', smartbuf.close_current_buffer)
vim.keymap.set('n', '<Leader>qa', smartbuf.close_all)
