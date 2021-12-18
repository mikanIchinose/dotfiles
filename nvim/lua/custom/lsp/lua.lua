local lsp = require('custom.lsp.config')

lsp.install_server('sumneko_lua')

USER = vim.fn.expand('$USER')

local sumneko_root_path = ""
local sumneko_binary = ""

if vim.fn.has("mac") == 1 then
    local mac = '/.local/share/nvim/lsp_servers/sumneko_lua/extension/server/bin/macOS'
    sumneko_root_path = "/Users/" .. USER .. mac
    sumneko_binary = "/Users/" .. USER .. mac .."/lua-language-server"
elseif vim.fn.has("unix") == 1 then
    local linux = '/.local/share/nvim/lsp_servers/sumneko_lua/extension/server/bin/Linux'
    sumneko_root_path = "/home/" .. USER .. linux
    sumneko_binary = "/home/" .. USER .. linux .. "/lua-language-server"
else
    print("Unsupported system for sumneko")
end

local path = vim.split(package.path, ';')
table.insert(path, 'lua/?.lua')
table.insert(path, 'lua/?/init.lua')
-- table.insert(path, '?.lua')
-- table.insert(path, '?/init.lua')

local library = {}
local function add_library(lib)
    for _, p in pairs(vim.fn.expand(lib, false, true)) do
        p = vim.loop.fs_realpath(p)
        if p then
            library[p] = true
        end
    end
end

add_library('$VIMRUNTIME')
add_library('$HOME/.config/nvim')
add_library '$HOME/.cache/dein/repos/github.com/*/*'

local luadev = require('lua-dev').setup({
  lspconfig = {
    cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    on_attach = lsp.cmmon_on_attach,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = path
        },
        diagnostics = {
          globals = {'vim'}
        },
        workspace = {
          library = library,
          --maxPreload = 10000,
          --preloadFileSize = 50000
        },
        telemetry = { enable = false }
      }
    }
  },
})

lsp.lspconfig.sumneko_lua.setup(luadev)
