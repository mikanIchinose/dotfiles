-- local function documentHighlight(client, bufnr)
--     if client.resolved_capabilities.document_highlight then
--         vim.cmd(
--             [[
--               hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
--               hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
--               hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
--               augroup lsp_document_highlight
--                 autocmd! * <buffer>
--                 autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
--                 autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
--               augroup END
--             ]],
--             false
--         )
--     end
-- end

local M = {}

M.installer = require 'nvim-lsp-installer'
M.servers = require 'nvim-lsp-installer.servers'
M.lspconfig = require 'lspconfig'

-- function M.common_on_attach(client, bufnr)
--     documentHighlight(client, bufnr)
-- end

-- string server: language server name
function M.install_server(server)
    local root_path = vim.fn.stdpath('data') .. '/lsp_servers/' .. server
    if vim.fn.empty(vim.fn.glob(root_path)) > 0 then
      M.installer.install(server)
    end
end

return M

