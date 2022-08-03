local lsp = require('custom.lsp.config')
local schemas = require('custom.lsp.json_schema')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp.lspconfig.jsonls.setup {
  capabilities = capabilities,
  cmd = { os.getenv("HOME") .. "/.local/share/nvim/lsp_servers/jsonls/node_modules/vscode-langservers-extracted/bin/vscode-json-language-server", "--stdio" },
  on_attach = lsp.on_attach,
  settings = {
    json = {
      schemas = {
        {
          fileMatch = {
            "deno.json",
            "deno.jsonc"
          },
          url = "https://raw.githubusercontent.com/denoland/deno/main/cli/schemas/config-file.v1.json"
        },
      }
    }
  }
}
