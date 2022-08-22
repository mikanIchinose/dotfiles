local formatting = require("null-ls").builtins.formatting
local diagnostics = require("null-ls").builtins.diagnostics
local code_actions = require("null-ls").builtins.code_actions
require("null-ls").setup({
  on_attach = function(client, _)
    require("lsp-format").on_attach(client)
  end,
  sources = {
    -- markdown
    formatting.markdownlint,
    diagnostics.markdownlint.with({
      args = { "-c", "~/.config/markdownlint/.markdownlintrc", "--stdin" }
    }),
    -- shell
    formatting.shfmt.with {
      args = { "-i", "2", "-filename", "$FILENAME" }
    },
    formatting.shellharden,
    diagnostics.shellcheck,
    code_actions.shellcheck,
  }
})
