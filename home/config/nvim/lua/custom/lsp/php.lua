local lsp = require('custom.lsp.config')

-- lsp.install_server('phpactor')
lsp.lspconfig.phpactor.setup {
  cmd = {"/Users/solenoid/.local/share/nvim/lsp_servers/phpactor-source/bin/phpactor", "language-server"},
  on_attach = lsp.on_attach,
}

