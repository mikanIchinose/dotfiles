require('lsp_lines').setup()

vim.g.is_virtual_lines = true

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
})

vim.api.nvim_create_user_command(
  'ToggleLspLines',
  function(_)
    vim.g.is_virtual_lines = require("lsp_lines").toggle()
  end,
  { nargs = 0 }
)

vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    vim.diagnostic.config({ virtual_lines = false })
  end
})
vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = 'i:*',
  callback = function()
    if vim.g.is_virtual_lines then
      vim.diagnostic.config({ virtual_lines = true })
    end
  end
})
