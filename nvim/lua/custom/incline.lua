require('incline').setup {
  render = function(props)
    local bufname = vim.api.nvim_buf_get_name(props.buf)
    if bufname == '' then
      return '[No name]'
    else
      bufname = vim.fn.fnamemodify(bufname, ':t')
      local icon = require("nvim-web-devicons").get_icon(bufname, nil, { default = true })
      return icon .. " " .. bufname
    end
  end,
  window = {
    width = 'fit',
    margin = {
      horizontal = { left = 1, right = 1 },
      vertical = { bottom = 0, top = 1 },
    },
    padding = { left = 1, right = 1 },
  },
  ignore = {
    floating_wins = true,
    unlisted_buffers = true,
    filetypes = {},
    buftypes = 'special',
    wintypes = 'special',
  },
}
