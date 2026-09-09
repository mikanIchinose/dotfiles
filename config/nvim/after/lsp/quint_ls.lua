-- quint_ls は nvim-lspconfig に定義がないため、cmd から全て記述する
---@type vim.lsp.Config
return {
  cmd = { 'quint-language-server', '--stdio' },
  filetypes = { 'quint' },
  root_markers = { '.git' },
}
