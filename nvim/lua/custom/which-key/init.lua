local wk = require('which-key')

wk.setup{
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = false, suggestions = 20, },
  },
  ignore_missing = false,
}

local comment = {
  name = '+comment',
  c = {'<Plug>(caw:hatpos:toggle)',       'toggle comment'},
  i = {'<Plug>(caw:hatpos:comment)',      'hatpos comment'},
  I = {'<Plug>(caw:zeropos:comment)',     'zeropos comment'},
  a = {'<Plug>(caw:dollarpos:comment)',   'dollarpos comment'},
  w = {'<Plug>(caw:wrap:comment)',        'wrap comment'},
  n = {'<Plug>(caw:jump:comment-next)',   'comment below'},
  p = {'<Plug>(caw:jump:comment-prev)',   'comment above'},
  u = {
    i = {'<Plug>(caw:hatpos:uncomment)',    'hatpos uncomment'},
    I = {'<Plug>(caw:zeropos:uncomment)',   'zeropos uncomment'},
    a = {'<Plug>(caw:dollarpos:uncomment)', 'dollarpos uncomment'},
    w = {'<Plug>(caw:wrap:uncomment)',      'wrap uncomment'},
  },
}

local find = {
  name = '+find',
  f = {'<cmd>Telescope find_files<cr>','find file'},
  r = {'<cmd>Telescope live_grep<cr>', 'find code'},
  b = {'<cmd>Telescope buffers<cr>',   'find buffer'},
  c = {'<cmd>Telescope commands<cr>',   'find command'},
  w = {'<cmd>Telescope file_browser<cr>' ,'file browser'},
  p = {'<cmd>lua require\'telescope\'.extensions.project.project{display_type=\'full\'}<cr>', 'switch project'},
  lsp = {
    a = {'<cmd>Telescope lsp_code_actions<cr>', 'code action'},
    f = {'<cmd>Telescope lsp_reference<cr>', 'reference'},
  }
}

local switch = {
  name = '+switch buffer',
  h = {'<C-w>h', 'left'},
  j = {'<C-w>j', 'down'},
  k = {'<C-w>k', 'up'},
  l = {'<C-w>l', 'right'},
}

-- nomal mode
wk.register({
  ['<leader>'] = {
    ['|'] = {':split<CR>',  'split horizontally'},
    ['-'] = {':vsplit<CR>', 'split vertically'},
    w = {':update<CR>', 'save current buffer'},
    W = {':wall<CR>',   'save all buffers'},
    q = {':quit<CR>', 'close current window'},
    Q = {':qall<CR>', 'close all windows'},
    o = {'o<ESC>', 'insert line above'},
    O = {'O<ESC>', 'insert line below'},
    n = {':nohl<CR>', 'turn highlight off'},
    c = comment,
    f = find,
  },
  ['<C-g>'] = find.lsp,
  gcc = comment.i,
  s = switch,
},{mode = 'n'})

-- visual mode
wk.register({
  gcc = comment.i,
},{mode = 'v'})
