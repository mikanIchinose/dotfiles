local lsp_installer = require("nvim-lsp-installer")
lsp_installer.setup {}
local lspconfig = require("lspconfig")
lspconfig.taplo.setup {
  cmd = {"/Users/solenoid/.local/share/nvim/lsp_servers/taplo/bin/taplo", "lsp", "stdio"}
  -- cmd = {"/Users/solenoid/.cargo/bin/taplo", "lsp", "stdio"}
}
