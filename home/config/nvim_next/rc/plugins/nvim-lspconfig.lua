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
--- }}}
