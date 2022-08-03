local M = {}

function M.on_attach(client, _)
  -- client.server_capabilities.document_formatting = true

  -- format on save
  require("lsp-format").on_attach(client)

  -- keymap
  require("which-key").register({
    g = {
      name = "goto",
      D = { vim.lsp.buf.declaration, "go declaration" },
      d = { vim.lsp.buf.definition, "go definition" },
      r = { vim.lsp.buf.references, "go reference" },
      i = { vim.lsp.buf.implementation, "go implementation" },
      t = { vim.lsp.buf.type_definition, "go type definition" },
    },
    ["[d"] = { vim.diagnostic.goto_prev, "go previous diagnostic" },
    ["]d"] = { vim.diagnostic.goto_next, "go next diagnostic" },
    K = { vim.lsp.buf.hover, "Hover" },
    ["<C-k>"] = { vim.lsp.buf.signature_help, "signature help" },
    ["<Leader>a"] = { [[<cmd>CodeActionMenu<CR>]], "code action" },
    ["<Leader>rn"] = { vim.lsp.buf.rename, "rename" },
  }, { mode = "n" })
end

return M
