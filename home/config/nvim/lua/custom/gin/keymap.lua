local map = vim.keymap.set
-- require('which-key').register({
--   ['<Leader>'] = {
--     g = {
--       name = '+git',
--       b = { '<Cmd>GinBranch -a<CR>', 'GinBranch' },
--       -- B = { '<Cmd>GinBuffer<CR>', 'GinBuffer' },
--       c = { '<Cmd>GinChaperon<CR>', 'GinChaperon' },
--       d = { '<Cmd>GinDiff ++processor=delta<CR>', 'GinDiff' },
--       -- e = { '<Cmd>GinEdit<CR>', 'GinEdit' },
--       s = { '<Cmd>GinStatus<CR>', 'GinStatus' },
--     },
--   },
-- })
map('n', '<Leader>gb', '<Cmd>GinBranch -a<CR>', { desc= 'GinBranch' })
map('n', '<Leader>gc', '<Cmd>GinChaperon<CR>', { desc= 'GinChaperon' })
map('n', '<Leader>gd', '<Cmd>GinDiff ++processor=delta<CR>', { desc= 'GinDiff' })
map('n', '<Leader>gs', '<Cmd>GinStatus<CR>', { desc= 'GinStatus' })
