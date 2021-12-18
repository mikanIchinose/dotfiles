require 'custom.lsp.sign_define'

-- vim.lsp.protocol.CompletionItemKind = {
  -- "   (Text) ",
  -- "   (Method)",
  -- "   (Function)",
  -- "   (Constructor)",
  -- " ﴲ  (Field)",
  -- "[] (Variable)",
  -- "   (Class)",
  -- " ﰮ  (Interface)",
  -- "   (Module)",
  -- " 襁 (Property)",
  -- "   (Unit)",
  -- "   (Value)",
  -- " 練 (Enum)",
  -- "   (Keyword)",
  -- "   (Snippet)",
  -- "   (Color)",
  -- "   (File)",
  -- "   (Reference)",
  -- "   (Folder)",
  -- "   (EnumMember)",
  -- " ﲀ  (Constant)",
  -- " ﳤ  (Struct)",
  -- "   (Event)",
  -- "   (Operator)",
  -- "   (TypeParameter)",
-- }

-- tomlファイルのときはLSPのdiagnosticを出さない
function disable_lsp_diagnostic()
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,{
      virtual_text = false,
      signs = false,
      underline = false,
    }
  )
  -- vim.diagnostic.config({virtual_text = false})
end

function enable_lsp_diagnostic()
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,{
      virtual_text = {
        prefix = "",
        spacing = 0,
      },
      signs = true,
      underline = true,
    }
  )
end

-- vim.cmd[[augroup toml]]
-- vim.cmd[[autocmd!]]
vim.cmd[[autocmd BufRead *.toml lua disable_lsp_diagnostic()]]
-- vim.cmd[[augroup END]]

-- vim.cmd[[augroup lua]]
-- vim.cmd[[autocmd!]]
vim.cmd[[autocmd BufRead *.lua lua enable_lsp_diagnostic()]]
-- vim.cmd[[augroup END]]

-- language specific setting
require 'custom.lsp.lua'
require 'custom.lsp.javascript'
-- require 'custom.lsp.vimL'
-- require 'custom.lsp.kotlin'
