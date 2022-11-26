-- 外部ツールセットアップ
require('custom.lsp.sign_define')
require('mason').setup()
local lspconfig = require('lspconfig')
local lspconfig_util = require('lspconfig.util')
local lspconfig_configs = require('lspconfig.configs')
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup()
require('neodev').setup()

-- vim.lsp.set_log_level('debug')

---@class LanguageServerSpec
---@field opts table

---@type LanguageServerSpec[]
local LS = {
  taplo = {
    opts = require('custom.lsp.toml').opts,
  },
  grammarly = {
    opts = {
      autostart = true,
    },
  },
  tsserver = {
    opts = require('custom.lsp.javascript').tsserver.opts,
  },
  denols = {
    opts = require('custom.lsp.javascript').denols.opts,
  },
  html = {
    opts = {},
  },
  emmet_ls = {
    opts = {},
  },
  cssls = {
    opts = {},
  },
  cssmodules_ls = {
    opts = {},
  },
  tailwindcss = {
    opts = {
      root_dir = function(fname)
        return lspconfig_util.root_pattern(
          'tailwind.config.js',
          'tailwind.config.ts'
          -- 'twind.config.js',
          -- 'twind.config.ts'
        )(fname)
      end,
      settings = {
        tailwindCSS = {
          emmetCompletions = true
        }
      }
    },
  },
  volar = {
    opts = {},
  },
  graphql = {
    opts = {
      filetypes = { 'graphql' },
    },
  },
  ltex = {
    opts = {
      autostart = false,
    },
  },
  marksman = {
    opts = {},
  },
  jsonls = {
    opts = require('custom.lsp.json').opts,
  },
  jsonnet_ls = {
    opts = {},
  },
  yamlls = {
    opts = require('custom.lsp.yaml').opts,
  },
  vimls = {
    opts = {},
  },
  sumneko_lua = {
    opts = require('custom.lsp.lua').opts,
  },
  rust_analyzer = {
    opts = {},
  },
  bashls = {
    opts = {},
  },
  -- {
  --   opts = {},
  -- },
}

---@class FormatterLinterSpec

---@class DapServerSpec

-- local language_servers = {
--   -- "eslint-lsp",
--   -- "golangci-lint-langserver",
--   -- "elm-language-server",
--   -- "remark-language-server", -- md
--   --
--   -- 'bash-language-server',
--   -- 'css-lsp',
--   -- 'cssmodules-language-server',
--   -- 'deno',
--   'dockerfile-language-server',
--   -- 'emmet-ls', -- html
--   -- 'graphql-language-service-cli',
--   'haskell-language-server',
--   -- 'html-lsp',
--   -- 'json-lsp',
--   -- 'jsonnet-language-server',
--   -- 'ltex-ls', -- md
--   -- 'lua-language-server',
--   -- 'marksman', -- md
--   -- 'rust-analyzer',
--   -- 'taplo', -- toml
--   -- 'typescript-language-server',
--   -- 'tailwindcss-language-server',
--   -- 'vim-language-server',
--   -- 'vue-language-server',
--   -- 'yaml-language-server',
--   -- 'grammarly-languageserver',
-- }
-- local formatters = {
--   'cbfmt', -- md
--   -- "elm-format",
--   'fixjson', -- とてもいいかんじにjsonをきれいにしてくれる
--   -- "gofumpt",
--   -- "goimports",
--   'jq',
--   -- "luaformatter",
--   'shellharden',
--   'shfmt',
--   'stylua', -- lua
--   'yamlfmt',
--   'prettierd',
-- }
-- local linters = {
--   'actionlint', -- github action workflow
--   -- "buf",
--   -- "codespell",
--   'cspell',
--   'editorconfig-checker',
--   -- "eslint_d", -- js/ts
--   'gitlint', -- gitcommit
--   -- "golangci-lint",
--   'hadolint', -- dockerfile
--   'luacheck',
--   'selene', -- lua
--   'shellcheck',
--   'markdownlint',
--   'textlint', -- md
--   'vale', -- md
--   'vint', -- vimscript
--   'yamllint',
-- }
-- local dap_servers = {
--   'bash-debug-adapter',
--   'chrome-debug-adapter',
--   -- "codelldb", -- rust
--   -- "delve", -- go
--   -- "firefox-debug-adapter",
--   -- "go-debug-adapter",
-- }
-- function table.merge(t1, t2)
--   for _, v in ipairs(t2) do
--     table.insert(t1, v)
--   end
-- end

-- local ensure_installed = {}
-- table.merge(ensure_installed, language_servers)
-- table.merge(ensure_installed, formatters)
-- table.merge(ensure_installed, linters)
-- table.merge(ensure_installed, dap_servers)
-- require('mason-tool-installer').setup({
--   ensure_installed = ensure_installed,
--   -- auto_update = true,
-- })

local on_attach = function(client, bufnr)
  -- format on save
  --require('lsp-format').on_attach(client)

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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

mason_lspconfig.setup_handlers({
  ---@param server_name string
  function(server_name)
    -- nvim-ufo
    -- capabilities.textDocument.foldingRange = {
    --   dynamicRegistration = false,
    --   lineFoldingOnly = true,
    -- }

    local opts = {
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        if
          server_name ~= 'tailwindcss'
          and server_name ~= 'grammarly'
          and server_name ~= 'cssmodules_ls'
          and server_name ~= 'ltex'
          and server_name ~= 'emmet_ls'
        then
          require('nvim-navic').attach(client, bufnr)
        end
      end,
      capabilities = capabilities,
    }
    if LS[server_name] ~= nil then
      for k, v in pairs(LS[server_name].opts) do
        opts[k] = v
      end
      lspconfig[server_name].setup(opts)
    end
  end,
})

-- unocss
lspconfig_configs['unocss'] = {
  default_config = {
    cmd = { 'unocss-language-server', '--stdio' },
    filetypes = {
      'html',
      'javascriptreact',
      'rescript',
      'typescriptreact',
      'vue',
      'svelte',
      'markdown',
    },
    on_new_config = function(new_config) end,
    root_dir = function(fname)
      return lspconfig_util.root_pattern('unocss.config.js', 'unocss.config.ts')(fname)
    end,
  },
}
lspconfig.unocss.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
