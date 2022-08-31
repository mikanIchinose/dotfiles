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

-- local deno_root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts")
-- local node_root_dir = lspconfig.util.root_pattern("package.json", "node_modules")
-- local is_deno_proj = detected_root_dir(deno_root_dir)
-- local is_node_proj = detected_root_dir(deno_root_dir) and not is_deno_proj

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
            'https://www.schemastore.org/api/json/catalog.json',
          },
          enable = true,
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

---@param server_name string
local function handler(server_name)
  ---@diagnostic disable-next-line: unused-local
  local on_attach = function(client, bufnr)
    -- format on save
    require('lsp-format').on_attach(client)

    -- keymap
    local code_action = {
      default = vim.lsp.buf.code_action,
      code_action_menu = [[<cmd>CodeActionMenu<CR>]],
    }
    local map = vim.keymap.set
    map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
    map('n', '<M-Enter>', function()
      vim.diagnostic.open_float(nil, { focusable = false, scope = 'cursor' })
    end)
    require('which-key').register({
      g = {
        name = 'goto',
        D = { vim.lsp.buf.declaration, 'go declaration' },
        d = { vim.lsp.buf.definition, 'go definition' },
        r = { vim.lsp.buf.references, 'go reference' },
        i = { vim.lsp.buf.implementation, 'go implementation' },
        t = { vim.lsp.buf.type_definition, 'go type definition' },
      },
      ['[d'] = { vim.diagnostic.goto_prev, 'go previous diagnostic' },
      [']d'] = { vim.diagnostic.goto_next, 'go next diagnostic' },
      -- K = { vim.lsp.buf.hover, "Hover" },
      -- ["<C-k>"] = { vim.lsp.buf.signature_help, "signature help" },
      ['<Leader>'] = {
        a = { code_action.code_action_menu, 'code action' },
        r = { vim.lsp.buf.rename, 'rename' },
      },
    }, { mode = 'n' })
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  if
    server_name == 'sumneko_lua'
    or server_name == 'jsonls'
    or server_name == 'yamlls'
    or server_name == 'taplo'
    or server_name == 'tsserver'
    or server_name == 'denols'
    or server_name == 'ltex'
  then
    server_ops[server_name](opts)
  end

  if server_name == 'sumneko_lua' then
    lspconfig[server_name].setup(require('lua-dev').setup({ lspconfig = opts }))
  else
    lspconfig[server_name].setup(opts)
  end
end

mason_lspconfig.setup_handlers({ handler })
