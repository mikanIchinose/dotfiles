local schemas = require('schemastore').json.schemas()
local M = {}
M.opts = {
  settings = {
    json = {
      schemas = schemas,
    },
  },
}

return M
