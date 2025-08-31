--- lua_source {{{
-- NOTE: Disable lsp watcher. Too slow on linux
-- https://github.com/neovim/neovim/issues/23725#issuecomment-1561364086
require('vim.lsp._watchfiles')._watchfunc = function()
  return function() end
end

-- vim.lsp.handlers['ttDocument/publishDiagnostics'] = vim.lsp.with(
--   vim.lsp.diagnostic.on_publish_diagnostics,
--   {
--     update_in_insert = false,
--     virtual_text = {
--       format = function(diagnostic)
--         return string.format(
--           '%s (%s: %s)',
--           diagnostic.message,
--           diagnostic.source,
--           diagnostic.code
--         )
--       end
--     },
--   }
-- )

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
    vim.keymap.set('n', 'dq', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<space>F', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- vim develop
vim.lsp.enable('vimls')
vim.lsp.enable('lua_ls')

-- config files(json, yaml, toml...)
vim.lsp.enable('jsonls')
-- vim.lsp.enable('yamlls')
vim.lsp.enable('gh_actions_ls')

-- web develop
vim.lsp.enable({
  'vtsls',
  'denols',
  'vue_ls',
  'emmet_language_server',
  'html',
  'cssls'
})
local vue_plugins = {
  name = '@vue/typescript-plugin',
  location = vim.fn.expand '$HOME/.nix-profile/bin/vue-language-server',
  languages = { 'vue' },
  configNamespace = 'typescript',
}
vim.lsp.config('vtsls', {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugins,
        }
      }
    }
  },
  filetype = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
})

vim.lsp.enable('efm')
vim.lsp.enable('nixd')
-- vim.lsp.enable('rust_analyzer')
vim.lsp.enable('clojure_lsp')
vim.lsp.enable('gopls')
-- --- }}}
