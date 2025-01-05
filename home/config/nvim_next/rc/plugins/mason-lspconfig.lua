--- lua_source {{{
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    "vimls",
    "lua_ls",
    "vtsls",
    "denols",
    "volar",
    -- "html", // autocompleteの妨げになってしまう
    "emmet_language_server",
    "cssls",
    -- "unocss",
    "taplo",
    "jsonls",
    "yamlls",
    "rust_analyzer",
    "hls",
    "clojure_lsp",
  }
})

-- https://zenn.dev/kawarimidoll/articles/2b57745045b225
require('mason-lspconfig').setup_handlers({
  function(server_name)
    local nvim_lsp = require('lspconfig')
    local nvim_lsp_util = require('lspconfig.util')
    local nvim_lsp_configs = require('lspconfig.configs')
    local is_node_repo = vim.fn.findfile('package-lock.json', '.;') ~= ''
    local schemas = require('schemastore').json.schemas()
    local capabilities = require('ddc_source_lsp').make_client_capabilities()

    local opts = {
      capabilities = capabilities,
      --on_attach = function(client, bufnr)
      --  -- format on save
      --  if client.supports_method('textDocument/formatting') then
      --    vim.api.nvim_create_autocmd('BufWritePre', {
      --      group = vim.api.nvim_create_augroup('LspFormat', { clear = true }),
      --      callback = function()
      --        vim.lsp.buf.format({ async = true })
      --      end,
      --    })
      --  end
      --end,
    }

    if server_name == '' then
      -- elseif server_name == 'unocss' then
      --   opts.filetypes = {
      --     "html",
      --     "markdown",
      --     "javascriptreact",
      --     "typescriptreact",
      --     "vue",
      --     "svelte",
      --   }
    elseif server_name == 'vtsls' then
      if not is_node_repo then return end

      opts.root_dir = nvim_lsp.util.root_pattern('package.json')
    elseif server_name == 'denols' then
      if is_node_repo then return end

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
    elseif server_name == 'lua_ls' then
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
    elseif server_name == 'hls' then
      opts.settings = { single_file_support = true }
    elseif server_name == 'taplo' then
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
    elseif server_name == 'jsonls' then
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
    elseif server_name == 'yamlls' then
      opts.settings = {
        yaml = {
          schemas = schemas,
        },
      }
    elseif server_name == 'volars' then
      -- https://github.com/vuejs/language-tools/discussions/606
      local function on_new_config(new_config, new_root_dir)
        local function get_typescript_server_path(root_dir)
          local project_root = nvim_lsp_util.find_node_modules_ancestor(root_dir)
          return project_root
              and (nvim_lsp_util.path.join(project_root, 'node_modules', 'typescript', 'lib'))
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
      local volar_root_dir = nvim_lsp_util.root_pattern 'package.json'

      nvim_lsp_configs.volar_api = {
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
      nvim_lsp.volar_api.setup({})

      nvim_lsp_configs.volar_doc = {
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
      nvim_lsp.volar_doc.setup({})

      nvim_lsp_configs.volar_html = {
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
      nvim_lsp.volar_html.setup({})

      return ""
    end

    nvim_lsp[server_name].setup(opts)
  end
})

require('lspconfig').unocss.setup({
  filetypes = {
    "html",
    "markdown",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
  }
})
--- }}}
