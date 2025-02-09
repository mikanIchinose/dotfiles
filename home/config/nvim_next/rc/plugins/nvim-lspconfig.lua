--- lua_source {{{
-- NOTE: Disable lsp watcher. Too slow on linux
-- https://github.com/neovim/neovim/issues/23725#issuecomment-1561364086
require('vim.lsp._watchfiles')._watchfunc = function()
  return function() end
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    update_in_insert = false,
    virtual_text = {
      format = function(diagnostic)
        return string.format(
          '%s (%s: %s)',
          diagnostic.message,
          diagnostic.source,
          diagnostic.code
        )
      end
    },
  }
)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspKeymap', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>F', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local capabilities = require('ddc_source_lsp').make_client_capabilities()
local lspconfig = require('lspconfig')
local lspconfigUtil = require('lspconfig.util')
local lspconfigConfig = require('lspconfig.configs')
local isNodeRepo = vim.fn.findfile('package-lock.json', '.;') ~= ''
local schemas = require('schemastore').json.schemas()
for _, lsp in pairs({
  "vimls",
  "lua_ls",
  "vtsls",
  "volar",
  "html",
  "emmet_language_server",
  "cssls",
  "taplo",
  "jsonls",
  "yamlls",
  "rust_analyzer",
  -- "hls",
  "clojure_lsp",
}) do
  local opts = {
    capabilities = capabilities,
  }
  if lsp == '' then
  elseif lsp == 'vtsls' then
    if not isNodeRepo then return end

    opts.root_dir = lspconfig.util.root_pattern('package.json')
  elseif lsp == 'denols' then
    if isNodeRepo then return end

    opts.init_options = {
      lint = true,
      unstable = true,
      documentPreloadLimit = 10,
      suggest = {
        autoImports = true,
        imports = {
          hosts = {
            ['https://deno.land'] = true,
          },
        },
      },
    }
  elseif lsp == 'lua_ls' then
    opts.settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = {
            'vim',
            'require'
          },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    }
    -- elseif server_name == 'hls' then
    --   opts.settings = { single_file_support = true }
  elseif lsp == 'taplo' then
    opts = {}
    opts.settings = {
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
        },
      },
    }
  elseif lsp == 'jsonls' then
    opts.filetypes = {
      "json",
      "jsonc",
      "json5",
    }
    opts.settings = {
      json = {
        schemas = schemas,
      },
    }
  elseif lsp == 'yamlls' then
    opts.settings = {
      yaml = {
        schemas = schemas,
      },
    }
  elseif lsp == 'volars' then
    -- https://github.com/vuejs/language-tools/discussions/606
    local function on_new_config(new_config, new_root_dir)
      local function get_typescript_server_path(root_dir)
        local project_root = lspconfigUtil.find_node_modules_ancestor(root_dir)
        return project_root
            and (lspconfigUtil.path.join(project_root, 'node_modules', 'typescript', 'lib'))
            or ''
      end

      if
          new_config.init_options
          and new_config.init_options.typescript
          and new_config.init_options.typescript.tsdk == ''
      then
        new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
      end
    end

    local volar_cmd = { 'vue-language-server', '--stdio' }
    local volar_root_dir = lspconfigUtil.root_pattern 'package.json'

    lspconfig.volar_api = {
      default_config = {
        cmd = volar_cmd,
        root_dir = volar_root_dir,
        on_new_config = on_new_config,
        filetypes = { 'vue' },
        init_options = {
          typescript = {
            tsdk = ''
          },
          languageFeatures = {
            implementation = true,
            references = true,
            definition = true,
            typeDefinition = true,
            callHierarchy = true,
            hover = true,
            rename = true,
            renameFileRefactoring = true,
            signatureHelp = true,
            codeAction = true,
            workspaceSymbol = true,
            completion = {
              defaultTagNameCase = 'both',
              defaultAttrNameCase = 'kebabCase',
              getDocumentNameCasesRequest = false,
              getDocumentSelectionRequest = false,
            },
          }
        },
      }
    }
    lspconfig.volar_api.setup({})

    lspconfigUtil.volar_doc = {
      default_config = {
        cmd = volar_cmd,
        root_dir = volar_root_dir,
        on_new_config = on_new_config,

        filetypes = { 'vue' },
        init_options = {
          typescript = {
            tsdk = ''
          },
          languageFeatures = {
            implementation = true, -- new in @volar/vue-language-server v0.33
            documentHighlight = true,
            documentLink = true,
            codeLens = { showReferencesNotification = true },
            semanticTokens = false,
            diagnostics = true,
            schemaRequestService = true,
          }
        },
      }
    }
    lspconfig.volar_doc.setup({})

    lspconfigConfig.volar_html = {
      default_config = {
        cmd = volar_cmd,
        root_dir = volar_root_dir,
        on_new_config = on_new_config,

        filetypes = { 'vue' },
        init_options = {
          typescript = {
            tsdk = ''
          },
          documentFeatures = {
            selectionRange = true,
            foldingRange = true,
            linkedEditingRange = true,
            documentSymbol = true,
            documentColor = false,
            documentFormatting = {
              defaultPrintWidth = 100,
            },
          }
        },
      }
    }
    lspconfig.volar_html.setup({})

    return ""
  end
  lspconfig[lsp].setup(opts)
end
--- }}}
