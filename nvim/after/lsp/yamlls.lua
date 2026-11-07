local schemas = require('schemastore').json.schemas()

---@type vim.lsp.Config
return {
  settings = {
    yaml = {
      format = {
        enable = true,
      },
      schemas = schemas,
    },
  },
}
