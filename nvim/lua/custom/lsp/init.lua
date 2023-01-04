-- 外部ツールセットアップ
require('custom.lsp.sign_define')
require('mason').setup()
local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require('lspconfig')
local lspconfig_util = require('lspconfig.util')
local lspconfig_configs = require('lspconfig.configs')
require('neodev').setup()
local schemas = require('schemastore').json.schemas()

-- vim.lsp.set_log_level('debug')

---@class LanguageServerSpec
---@field opts table

---@type LanguageServerSpec[]
local LS = {
  taplo = {
    opts = {
      settings = {
        evenBetterToml = {
          schema = {
            associations = {
              ['^(.*(/|\\\\)\\.*dein.*\\.toml|\\.*dein.*\\.toml)$'] = 'https://json.schemastore.org/dein.json',
              ['^(.*(/|\\\\)Cargo\\.toml|Cargo\\.toml)$'] = 'https://json.schemastore.org/cargo.json',
              ['^(.*(/|\\\\)\\.?rustfmt\\.toml|rustfmt\\.toml)$'] = 'https://json.schemastore.org/rustfmt.json',
              ['^(.*(/|\\\\)rust-toolchain([.]toml)?)$'] = 'https://json.schemastore.org/rust-toolchain.json',
              ['\\.*fly(.*)?\\.toml?$'] = 'https://json.schemastore.org/fly.json',
              ['^(.*(/|\\\\)Makefile\\.toml|Makefile\\.toml)$'] = 'https://json.schemastore.org/cargo-make.json',
              ['^(.*(/|\\\\)pyproject\\.toml|pyproject\\.toml)$'] = 'https://json.schemastore.org/pyproject.json',
              ['\\.replit(?:\\.toml)?$'] = 'https://json.schemastore.org/replit.json',
              ['^(.*(/|\\\\)starship/config\\.toml|starship/config\\.toml)$'] = 'https://starship.rs/config-schema.json',
              ['\\.golangci\\.toml'] = 'https://json.schemastore.org/golangci-lint.json',
            },
            enable = true,
          },
          formatter = {
            alignEntries = true,
            alignComments = true,
            arrayTrailingComma = true,
            arrayAutoExpand = true,
            inlineTableExpand = true,
            arrayAutoCollapse = true,
            -- compactArrays = true,
            -- compactInlineTables = true,
            -- compactEntries = true,
          },
        },
      },
    },
  },
  grammarly = {
    opts = {
      autostart = true,
    },
  },
  tsserver = {
    opts = {
      root_dir = lspconfig_util.root_pattern('node_modules'),
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    },
  },
  denols = {
    opts = {
      root_dir = lspconfig_util.root_pattern('deno.json', 'deno.jsonc', 'deps.ts', 'import_map.json', 'mod.ts'),
      init_options = {
        enable = true,
        lint = true,
        unstable = true,
      },
    },
  },
  html = {
    opts = {},
  },
  -- emmet_ls = {
  --   opts = {},
  -- },
  cssls = {
    opts = {},
  },
  -- cssmodules_ls = {
  --   opts = {},
  -- },
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
      -- settings = {
      --   tailwindCSS = {
      --     emmetCompletions = true,
      --   },
      -- },
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
    opts = {
      settings = {
        json = {
          schemas = schemas,
        },
      },
    },
  },
  jsonnet_ls = {
    opts = {},
  },
  yamlls = {
    opts = {
      settings = {
        yaml = {
          schemas = schemas,
        },
      },
    },
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
  rome = {
    opts = {
      root_dir = lspconfig_util.root_pattern('rome.json'),
      autostart = false,
    },
  },
  julials = {
    opts = {},
  },
  -- server = {
  --   opts = {},
  -- },
}
local function get_keys(t)
  local keys = {}
  for key, _ in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end

mason_lspconfig.setup({
  ensure_installed = get_keys(LS),
  automatic_installation = true,
})

---@class FormatterLinterSpec

---@class DapServerSpec

local setKeymap = function()
  -- keymap
  local code_action = {
    default = vim.lsp.buf.code_action,
    code_action_menu = [[<cmd>CodeActionMenu<CR>]],
  }
  local map = vim.keymap.set
  map('n', 'gd', vim.lsp.buf.definition, { desc = 'definition' })
  map('n', 'gD', vim.lsp.buf.declaration, { desc = 'declaration' })
  map('n', 'gr', vim.lsp.buf.references, { desc = 'reference' })
  map('n', 'gi', vim.lsp.buf.implementation, { desc = 'implementation' })
  map('n', 'gt', vim.lsp.buf.type_definition, { desc = 'type definition' })
  map('n', 'K', vim.lsp.buf.hover)
  map('n', '<Leader>a', code_action.code_action_menu, { desc = 'code action' })
  map('n', '<Leader>r', vim.lsp.buf.rename, { desc = 'rename' })
  map('n', '<C-g>', function()
    vim.diagnostic.open_float(nil, { focusable = false, scope = 'cursor' })
  end)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

mason_lspconfig.setup_handlers({
  ---@param server_name string
  function(server_name)
    -- nvim-ufo
    -- if
    --   server_name == 'denols' or server_name == 'tsserver'
    --   -- or server_name == 'cssmodules_ls'
    --   -- or server_name == 'ltex'
    --   -- or server_name == 'emmet_ls'
    -- then
    --   capabilities.textDocument.foldingRange = {
    --     dynamicRegistration = false,
    --     lineFoldingOnly = true,
    --   }
    -- end

    local opts = {
      on_attach = function(client, bufnr)
        setKeymap()

        -- format on save
        require('lsp-format').on_attach(client)
        -- require('lsp-inlayhints').on_attach(client, bufnr)

        if
          server_name ~= 'tailwindcss'
          and server_name ~= 'grammarly'
          and server_name ~= 'cssmodules_ls'
          and server_name ~= 'ltex'
          and server_name ~= 'emmet_ls'
          and server_name ~= 'rome'
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
      -- 'javascriptreact',
      -- 'rescript',
      'typescriptreact',
      -- 'vue',
      -- 'svelte',
      'markdown',
    },
    on_new_config = function(new_config) end,
    root_dir = function(fname)
      return lspconfig_util.root_pattern('unocss.config.js', 'unocss.config.ts')(fname)
    end,
  },
}
lspconfig.unocss.setup({
  on_attach = setKeymap,
  capabilities = capabilities,
})
