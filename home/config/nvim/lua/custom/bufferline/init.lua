require("bufferline").setup {
  options = {
    diagnostics = 'nvim_lsp',
    groups = {
      options = {
        toggle_hidden_on_enter = true
      },
      items = {
        {
          name = "docs",
          matcher = function(buf)
            return buf.name:match('%.md') or buf.name:match('%.txt')
          end,
          separator = {
            style = require("bufferline.groups").separator.tab
          },
        },
      }
    },
  }
}
