local runtimePath = vim.split(package.path, ';')
table.insert(runtimePath, 'lua/?.lua')
table.insert(runtimePath, 'lua/?/init.lua')

local library = vim.api.nvim__get_runtime({ '' }, true, { is_lua = true })
for i = 1, #library do
  library[i] = vim.loop.fs_realpath(library[i])
end

local M = {}
-- M.sumneko_lua = function(opts)
--   opts.settings = {
--     Lua = {
--       format = {
--         enable = false,
--         defaultConfig = {
--           indent_style = 'space',
--           indent_size = 2,
--         },
--       },
--       runtime = {
--         version = 'LuaJIT',
--         path = runtimePath,
--       },
--       diagnostics = {
--         globals = { 'vim' },
--         neededFileStatus = {
--           ['codestyle-check'] = 'Any',
--         },
--       },
--       workspace = {
--         library = library,
--         chackThirdParty = false,
--       },
--       telemetry = { enable = false },
--       completion = { keywordSnippet = 'Replace' },
--       inlayHints = { enable = true },
--     },
--   }
-- end
M.opts = {
  settings = {
    Lua = {
      format = {
        enable = false,
        defaultConfig = {
          -- indent_style = 'space',
          indent_size = 2,
        },
      },
      runtime = {
        version = 'LuaJIT',
        path = runtimePath,
      },
      diagnostics = {
        globals = { 'vim' },
        neededFileStatus = {
          ['codestyle-check'] = 'Any',
        },
      },
      workspace = {
        library = library,
        chackThirdParty = false,
      },
      telemetry = { enable = false },
      completion = { keywordSnippet = 'Replace' },
    },
  },
}

return M
