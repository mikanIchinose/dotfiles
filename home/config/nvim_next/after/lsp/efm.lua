local actionlint = require('efmls-configs.linters.actionlint')
local yamllint = require('efmls-configs.linters.yamllint')

---@type vim.lsp.Config
return {
  filetypes = {
    'json',
    'yaml'
  },
  init_options = {
    documentFormatting = true,
    rangeFormatting = true,
    hover = true,
    documentSymbol = true,
    codeAction = true,
    completion = false,
  },
  settings = {
    languages = {
      json = {
        -- { kind = 'formatters', name = 'jq' },
        -- { kind = 'linters',    name = 'jq' },
      },
      yaml = {
        -- yamllint,
        actionlint,
      },
    }
  }
}
