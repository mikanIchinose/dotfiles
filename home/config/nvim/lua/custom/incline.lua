---@class InclineRenderProps
---@field buf number
---@field win number

require('incline').setup({
  -- highlight = {
  --   groups = {
  --     InclineNormal = {
  --       group = 'Cursor'
  --     },
  --   }
  -- },
  ---@param props InclineRenderProps
  render = function(props)
    local bufname = vim.api.nvim_buf_get_name(props.buf)
    if bufname == '' then
      return '[No name]'
    else
      local filename_and_path = vim.fn.fnamemodify(bufname, ':.')
      local filename = vim.fn.fnamemodify(bufname, ':t')
      local extention = vim.fn.fnamemodify(bufname, ':e')
      local icon, color = require('nvim-web-devicons').get_icon_color(filename, extention, { default = true })
      return {
        {
          icon,
          guifg = color,
        },
        { ' ' },
        { filename_and_path },
      }
    end
  end,
  window = {
    width = 'fit',
    margin = {
      horizontal = { left = 1, right = 1 },
      vertical = { bottom = 0, top = 0 },
    },
    padding = { left = 1, right = 1 },
    -- winhighlight = {
    --   Normal = 'Cursor'
    -- }
  },
  ignore = {
    filetypes = { 'gitcommit' },
    -- floating_wins = true,
    -- unlisted_buffers = true,
    -- buftypes = 'special',
    -- wintypes = 'special',
  },
})
