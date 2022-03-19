--- @diagnostic disable: lowercase-global

-- vim.diagnostic.config({
  -- virtual_text = false,
  -- signs = true,
  -- underline = true,
-- })

-- diagnosticが出力されたときのデフォの挙動
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
  }
)

-- tomlファイルのときはLSPのdiagnosticを出さない
-- function disable_lsp_diagnostic()
--   vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
--     vim.lsp.diagnostic.on_publish_diagnostics,
--     {
--       virtual_text = false,
--       signs = false,
--       underline = false,
--     }
--   )
-- end

-- function enable_lsp_diagnostic()
--   vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
--     vim.lsp.diagnostic.on_publish_diagnostics,
--     {
--       virtual_text = false,
--       signs = true,
--       underline = true,
--     }
--   )
-- end

-- vim.cmd[[
-- augroup toml
-- autocmd!
-- autocmd BufRead *.toml lua disable_lsp_diagnostic()
-- augroup END
-- ]]
-- 
-- vim.cmd[[
-- augroup lua
-- autocmd!
-- autocmd BufRead *.lua lua enable_lsp_diagnostic()
-- augroup END
-- ]]

require 'custom.lsp.sign_define'

-- format on save
vim.cmd [[
autocmd BufWritePre *ts lua vim.lsp.buf.formatting_sync(nil, 1000)
]]

-- language specific setting
require('custom.lsp.javascript')
require('custom.lsp.php')
-- require 'custom.lsp.vimL'
-- require 'custom.lsp.kotlin'
