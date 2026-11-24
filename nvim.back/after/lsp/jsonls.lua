local schemas = require('schemastore').json.schemas()

---@type vim.lsp.Config
return {
  settings = {
    json = {
      schemas = schemas,
    },
  },
  filetypes = {
    "json",
    "jsonc",
    "json5",
  },
}
