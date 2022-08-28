M = {}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local library = vim.api.nvim__get_runtime({ '' }, true, { is_lua = true })
for i = 1, #library do
  library[i] = vim.loop.fs_realpath(library[i])
end

M.sumneko_lua = function(opts)
  opts.settings = {
    Lua = {
      format = {
        enable = false,
        defaultConfig = {
          indent_style = 'space',
          indent_size = 2,
        },
      },
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
        neededFileStatus = {
          ['codestyle-check'] = 'Any',
        },
      },
      workspace = {
        library = library,
      },
      telemetry = { enable = false },
      completion = { keywordSnippet = 'Replace' },
    },
  }
end

return M