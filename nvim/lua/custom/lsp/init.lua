vim.lsp.set_log_level("debug")

local lspconfig = require("lspconfig")

require("custom.lsp.sign_define")
require('lsp-format').setup {}
require("mason").setup {}
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup {
  automatic_installation = true,
}


---@param root_dir function
local function detected_root_dir(root_dir)
  return not not (root_dir(vim.api.nvim_buf_get_name(0), vim.api.nvim_get_current_buf()))
end

local deno_root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts")
local node_root_dir = lspconfig.util.root_pattern("package.json", "node_modules")
local is_deno_proj = detected_root_dir(deno_root_dir)
local is_node_proj = not is_deno_proj

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local server_ops = {
  ["sumneko_lua"] = function(opts)
    opts.settings = {
      Lua = {
        format = {
          enable = true,
          defaultConfig = {
            indent_style = "space",
            indent_size = 2,
          },
        },
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
          neededFileStatus = {
            ["codestyle-check"] = "Any"
          },
        },
        workspace = {
          library = {
            ---@diagnostic disable-next-line: missing-parameter
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
            ---@diagnostic disable-next-line: missing-parameter
            [vim.fn.expand("$HOME/.cache/dein/repos/github.com/**/lua")] = true,
          },
        },
        telemetry = { enable = false },
        completion = { keywordSnippet = "Replace" },
      },
    }
  end,
  ["jsonls"] = function(opts)
    opts.settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
      },
    }
  end,
  ["yamlls"] = function(opts)
    opts.settings = {
      yaml = {
        schemas = require("schemastore").json.schemas(),
      },
    }
  end,
  ["taplo"] = function(opts)
    opts.settings = {
      evenBetterToml = {
        schema = {
          -- associations = {
          --   -- [ [[ ^(.*(/|\\)dein(/|\\).*\.toml)$ ]] ] = "https://taplo.tamasfe.dev/schemas/dein.toml.json",
          --   ["^(.*(/|\\\\)\\.*dein.*\\.toml|\\.*dein.*\\.toml)$)"] = "https://taplo.tamasfe.dev/schemas/dein.toml.json",
          --   ["^(.*(/|\\\\)starship(/|\\).*\\.toml)$"] = "https://raw.githubusercontent.com/starship/starship/master/.github/config-schema.json",
          --   ["^(.*(/|\\\\)\\.?taplo\\.toml|\\.?taplo\\.toml)$"] = "taplo://taplo.toml",
          -- },
          catalogs = {
            "https://taplo.tamasfe.dev/schema_index.json",
            "https://www.schemastore.org/api/json/catalog.json",
          },
          enable = true,
          -- repositoryEnabled = true,
          -- repositoryUrl = "https://taplo.tamasfe.dev/schema_index.json",
        },
        formatter = {
          alignEntries = true
        },
      },
    }
  end,
  ["tsserver"] = function(opts)
    opts.autostart = is_node_proj
    -- if is_node_proj then
    opts.root_dir = node_root_dir
    opts.init_options = { lint = true, unstable = true }
    -- opts.on_attach = function(client, bufnr)
    --   client.resolved_capabilities.document_formatting = false
    -- on_attach(client, bufnr)
    -- end
    -- end
  end,
  ["denols"] = function(opts)
    opts.autostart = is_deno_proj
    -- if is_deno_proj then
    opts.root_dir = deno_root_dir
    opts.init_options = { lint = true, unstable = true }
    -- end
  end,
}

-- for server_name in pairs(server_ops) do
--   local opts = {
--     on_attach = require("custom.lsp.config").on_attach,
--     capabilities = capabilities,
--   }
--   server_ops[server_name](opts)
--   if server_name == "sumneko_lua" then
--     lspconfig[server_name].setup(require("lua-dev").setup({ lspconfig = opts }))
--   else
--     lspconfig[server_name].setup(opts)
--   end
-- end

mason_lspconfig.setup_handlers({ function(server_name)
  ---@diagnostic disable-next-line: unused-local
  local on_attach = function(client, bufnr)
    -- format on save
    require("lsp-format").on_attach(client)

    -- keymap
    local map = vim.keymap.set
    map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
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
      -- K = { vim.lsp.buf.hover, "Hover" },
      ["<C-k>"] = { vim.lsp.buf.signature_help, "signature help" },
      ["<Leader>a"] = { [[<cmd>CodeActionMenu<CR>]], "code action" },
      ["<Leader>rn"] = { vim.lsp.buf.rename, "rename" },
    }, { mode = "n" })
  end

  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  if server_name == "sumneko_lua"
      or server_name == "jsonls"
      or server_name == "yamlls"
      or server_name == "taplo"
      or server_name == "tsserver"
      or server_name == "denols"
  then
    server_ops[server_name](opts)
  end

  if server_name == "sumneko_lua" then
    lspconfig[server_name].setup(require("lua-dev").setup({ lspconfig = opts }))
  else
    lspconfig[server_name].setup(opts)
  end
end })

vim.keymap.set("n", "<M-Enter>", function()
  vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor" })
end)
