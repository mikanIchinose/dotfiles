local lsp = require('custom.lsp.config')

lsp.lspconfig.dartls.setup {
  on_attach = lsp.on_attach,
  dart = {
    enableSdkFormatter = true,
  }
}
