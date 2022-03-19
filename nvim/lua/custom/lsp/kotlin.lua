local lsp = require('custom.lsp.config')

-- if not lsp.servers.is_server_installed 'kotlin' then
  -- lsp.installer.install 'kotlin_language_server'
-- end

-- local kotlin_ls_binary = vim.fn.expand("~") .. '/.local/share/nvim/lsp_servers/kotlin/server/bin/kotlin-language-server'
local kotlin_ls_binary = vim.fn.expand("~") .. '/LocalProject/kotlin-language-server/server/build/install/server/bin/kotlin-language-server'

lsp.lspconfig.kotlin_language_server.setup {
  on_attach = lsp.on_attach,
  cmd = { kotlin_ls_binary }
}
