-- ui2 の通知（msg ウィンドウ）を右上の枠付きフローティングウィンドウにする
-- ui2 の内部関数 set_pos を上書きしている。nightly の更新で壊れることがある
local ui2 = require('vim._core.ui2')
local msgs = require('vim._core.ui2.messages')

local maxwidth = 60

local set_pos = msgs.set_pos
msgs.set_pos = function(tgt, ...)
  local win = ui2.wins.msg
  local target = (tgt == 'msg' or tgt == nil) and vim.api.nvim_win_is_valid(win)
  -- 先に幅を狭める。元の set_pos が折り返し込みで高さを計算する
  if target and vim.api.nvim_win_get_width(win) > maxwidth then
    vim.api.nvim_win_set_width(win, maxwidth)
  end
  set_pos(tgt, ...)
  if target and not vim.api.nvim_win_get_config(win).hide then
    vim.api.nvim_win_set_config(win, {
      relative = 'editor', anchor = 'NE', row = 0, col = vim.o.columns, border = 'rounded',
    })
  end
end
