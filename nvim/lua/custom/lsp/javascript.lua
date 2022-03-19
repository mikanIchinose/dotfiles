local lsp = require('custom.lsp.config')

-- Deno
-- lsp.install_server('denols')
lsp.lspconfig.denols.setup {
  on_attach = lsp.on_attach,
  filetypes = { "typescript" },
  init_options = {
    enable = true,
    lint = true,
    unstable = true,
    -- importMap = '../import_map.json',
  },
  root_dir = lsp.lspconfig.util.root_pattern("deno.json", "deno.jsonc", ".git", "mod.ts"),
}

-- Tssever
-- lsp.install_server 'tsserver'
-- lsp.lspconfig.tsserver.setup{}
