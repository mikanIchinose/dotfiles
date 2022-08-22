require 'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',
  ignore_install = { 'rnoweb', 'phpdoc' },
  highlight = {
    enable = true,
    disable = {
      'lua',
      -- 'vim',
      -- 'toml',
      -- 'fish',
    },
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
  },
  indent = {
    enable = false,
  },
  -- JoosepAlviste/nvim-ts-context-commentstring
  -- context_commentstring = {
  --   enable = true,
  -- },
  -- p00f/nvim-ts-rainbow
  rainbow = {
    enable = true,
    exteded_mode = true,
    max_file_lines = 1000,
  },
}
