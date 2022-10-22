-- vim.lsp.set_log_level('debug')

local language_servers = {
  'bash-language-server',
  -- 'css-lsp',
  -- "cssmodules-language-server",
  'deno',
  'dockerfile-language-server',
  -- "elm-language-server",
  'emmet-ls', -- html
  -- "eslint-lsp",
  -- "golangci-lint-langserver",
  'graphql-language-service-cli',
  'haskell-language-server',
  -- "html-language-server",
  'json-lsp',
  'jsonnet-language-server',
  'ltex-ls', -- md
  'lua-language-server',
  'marksman', -- md
  -- "remark-language-server", -- md
  -- "rust-analyzer",
  'taplo', -- toml
  'typescript-language-server',
  -- "tailwindcss-language-server",
  'vim-language-server',
  'yaml-language-server',
}
local formatters = {
  'cbfmt', -- md
  -- "elm-format",
  'fixjson', -- とてもいいかんじにjsonをきれいにしてくれる
  -- "gofumpt",
  -- "goimports",
  'jq',
  -- "luaformatter",
  'shellharden',
  'shfmt',
  'stylua', -- lua
  'yamlfmt',
  'prettierd',
}
local linters = {
  'actionlint', -- github action workflow
  -- "buf",
  -- "codespell",
  'cspell',
  'editorconfig-checker',
  -- "eslint_d", -- js/ts
  'gitlint', -- gitcommit
  -- "golangci-lint",
  'hadolint', -- dockerfile
  'luacheck',
  'selene', -- lua
  'shellcheck',
  'markdownlint',
  'textlint', -- md
  'vale', -- md
  'vint', -- vimscript
  'yamllint',
}
local dap_servers = {
  'bash-debug-adapter',
  'chrome-debug-adapter',
  -- "codelldb", -- rust
  -- "delve", -- go
  -- "firefox-debug-adapter",
  -- "go-debug-adapter",
}
function table.merge(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

local ensure_installed = {}
table.merge(ensure_installed, language_servers)
table.merge(ensure_installed, formatters)
table.merge(ensure_installed, linters)
table.merge(ensure_installed, dap_servers)
require('mason-tool-installer').setup({
  ensure_installed = ensure_installed,
  -- auto_update = true,
})

require('custom.lsp.sign_define')
require('lsp-format').setup()
require('mason').setup()

local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
  -- automatic_installation = true,
})

-- local function detected_root_dir(root_dir)
--   return not not (root_dir(vim.api.nvim_buf_get_name(0), vim.api.nvim_get_current_buf()))
-- end

local server_ops = {
  ['sumneko_lua'] = require('custom.lsp.lua').sumneko_lua,
  ['tsserver'] = require('custom.lsp.javascript').tsserver,
  ['denols'] = require('custom.lsp.javascript').denols,
  ['jsonls'] = function(opts)
    local schemas = require('schemastore').json.schemas()
    opts.settings = {
      json = {
        schemas = schemas,
      },
    }
  end,
  ['yamlls'] = function(opts)
    local schemas = require('schemastore').json.schemas()
    opts.settings = {
      yaml = {
        schemas = schemas,
      },
    }
  end,
  ['taplo'] = function(opts)
    opts.settings = {
      evenBetterToml = {
        schema = {
          catalogs = {
            'https://taplo.tamasfe.dev/schema_index.json',
            -- 古いスキーマが使われている
            -- 'https://www.schemastore.org/api/json/catalog.json',
          },
          enable = true,
          -- associations = {},
        },
        formatter = {
          alignEntries = true,
        },
      },
    }
  end,
  ['ltex'] = function(opts)
    opts.autostart = false
  end,
}

local on_attach = function(client, bufnr)
  -- format on save
  require('lsp-format').on_attach(client)
  -- lsp symbol
  require('nvim-navic').attach(client, bufnr)

  -- keymap
  local code_action = {
    default = vim.lsp.buf.code_action,
    code_action_menu = [[<cmd>CodeActionMenu<CR>]],
  }
  require('which-key').register({
    g = {
      name = 'goto',
      D = { vim.lsp.buf.declaration, 'go declaration' },
      d = { vim.lsp.buf.definition, 'go definition' },
      r = { vim.lsp.buf.references, 'go reference' },
      i = { vim.lsp.buf.implementation, 'go implementation' },
      t = { vim.lsp.buf.type_definition, 'go type definition' },
    },
    K = { vim.lsp.buf.hover, 'Hover' },
    ['[d'] = { vim.diagnostic.goto_prev, 'go previous diagnostic' },
    [']d'] = { vim.diagnostic.goto_next, 'go next diagnostic' },
    ['<Leader>'] = {
      a = { code_action.code_action_menu, 'code action' },
      r = { vim.lsp.buf.rename, 'rename' },
    },
    ['<C-g>'] = {
      function()
        vim.diagnostic.open_float(nil, { focusable = false, scope = 'cursor' })
      end,
      'open float',
    },
  }, { mode = 'n' })
end

---@param server_name string
local function handler(server_name)
  if server_name == 'sumneko_lua' then
    require('neodev').setup({})
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- nvim-ufo
  -- capabilities.textDocument.foldingRange = {
  --   dynamicRegistration = false,
  --   lineFoldingOnly = true,
  -- }

  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- update option specified server
  local updateOpts = server_ops[server_name]
  if updateOpts ~= nil then
    updateOpts(opts)
  end

  lspconfig[server_name].setup(opts)
end

mason_lspconfig.setup_handlers({ handler })
