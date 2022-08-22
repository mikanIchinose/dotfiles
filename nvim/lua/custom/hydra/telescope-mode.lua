local hydra = require('hydra')
local cmd = require('hydra.keymap-util').cmd

local hint = [[
_f_: files    _g_: live grep
_h_: vim help _c_: execute command
^
_<Enter>_: Telescope _<Esc>_
]]
hydra({
  name = 'Telescope',
  hint = hint,
  config = {
    color = 'teal',
    invoke_on_body = true,
    hint = {
      position = 'middle',
      border = 'rounded',
    },
  },
  mode = 'n',
  body = ',f',
  heads = {
    { 'f', cmd 'Telescope find_files' },
    { 'g', cmd 'Telescope live_grep' },
    { 'h', cmd 'Telescope help_tags', { desc = 'vim help' } },
    { 'c', cmd 'Telescope commands', { desc = 'execute command' } },
    { '<Enter>', cmd 'Telescope', { exit = true, desc = 'list all pickers' } },
    { '<Esc>', nil, { exit = true, nowait = true } },
  },
})
