local schemas = require('schemastore').json.schemas()
local M = {}
M.opts = {
  settings = {
    yaml = {
      schemas = schemas,
    },
  },
}

return M
