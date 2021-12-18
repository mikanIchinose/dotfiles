local lsp = require('custom.lsp.config')

-- Deno
lsp.install_server 'denols'
lsp.lspconfig.denols.setup{
  filetypes = { "typescript" },
  init_options = {
    enable = true,
    lint = true,
    unstable = true
  },
}

-- Tssever
-- lsp.install_server 'tsserver'
-- lsp.lspconfig.tsserver.setup{}
