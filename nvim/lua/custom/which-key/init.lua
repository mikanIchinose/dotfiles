local wk = require('which-key')

wk.setup {
  --  plugins = {
  --    marks = true,
  --    registers = true,
  --    spelling = { enabled = false, suggestions = 20, },
  --  },
  --  layout = {
  --    align = 'center',
  --  },
  --  ignore_missing = false,
}

wk.register(
  {
    ['<leader>'] = {
      ['-'] = { ':split<CR>', 'split horizontally' },
      ['\\'] = { ':vsplit<CR>', 'split vertically' },
      n = { ':nohl<CR>', 'turn highlight off' },
      h = { name = '+resize height' },
      w = { name = '+resize width' },
    },
    gcc = { 'toggle comment' },
    s = { name = '+switch buffer' },
  },
  { mode = 'n' }
)

wk.register(
  {
    gc = { 'toggle comment' },
  },
  { mode = 'v' }
)
