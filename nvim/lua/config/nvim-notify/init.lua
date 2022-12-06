-- NOTE: show lsp message
-- table from lsp severity to vim severity.
local severity = {
  "error",
  "warn",
  "info",
  "info", -- map both hint and info to info?
}
vim.lsp.handlers["window/showMessage"] = function(_, method, params, _)
  vim.notify(method.message, severity[params.type])
end
