local formatting = require('null-ls').builtins.formatting
local diagnostics = require('null-ls').builtins.diagnostics
local code_actions = require('null-ls').builtins.code_actions
require('null-ls').setup({
  --on_attach = function(client, _)
  --  require('lsp-format').on_attach(client)
  --end,
  sources = {
    -- formatting.deno_fmt.with({ filetypes = {''} }),
    formatting.prettierd.with({
      filetypes = { 'graphql' },
    }),
    -- text
    -- diagnostics.cspell,
    -- diagnostics.vale,
    diagnostics.textlint.with({
      filetypes = { 'markdown' },
    }),
    -- editorconfig
    -- diagnostics.editorconfig_checker,
    -- fish
    diagnostics.fish,
    -- zsh
    diagnostics.zsh,
    -- markdown
    -- formatting.markdownlint,
    formatting.cbfmt,
    -- diagnostics.markdownlint.with({
    --   args = { '-c', '~/.config/markdownlint/.markdownlintrc', '--stdin' },
    -- }),
    -- shell
    formatting.shfmt.with({
      args = { '-i', '2', '-filename', '$FILENAME' },
    }),
    formatting.shellharden,
    diagnostics.shellcheck,
    code_actions.shellcheck,
    -- lua
    diagnostics.luacheck.with({
      args = {
        '--globals',
        'vim',
        'table',
        '--formatter',
        'plain',
        '--codes',
        '--ranges',
        '--filename',
        '$FILENAME',
        '-',
      },
    }),
    -- diagnostics.selene,
    formatting.stylua,
    -- vimscript
    diagnostics.vint,
    -- git
    code_actions.gitsigns,
    diagnostics.gitlint,
    -- github action
    -- diagnostics.actionlint,
    -- dockerfile
    -- diagnostics.hadolint,
    -- json
    formatting.fixjson,
  },
})
