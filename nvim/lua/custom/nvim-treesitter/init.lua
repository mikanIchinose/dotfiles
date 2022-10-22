local config = {
  ensure_installed = 'all',
  ignore_install = { 'rnoweb', 'phpdoc' },
  highlight = {
    enable = true,
    disable = {
      'lua',
      -- 'vim',
      'toml',
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
}

local ts_comment_string_ok, _ = pcall(require, 'ts_comment_string')
local ts_rainbow_ok, _ = pcall(require, 'rainbow')
if ts_comment_string_ok then
  config.context_commentstring = {
    enable = true,
  }
end
if ts_rainbow_ok then
  config.rainbow = {
    enable = true,
    exteded_mode = true,
    max_file_lines = 10000,
  }
end
require('nvim-treesitter.configs').setup(config)
-- require('nvim-treesitter.configs').setup({
--   ensure_installed = 'all',
--   ignore_install = { 'rnoweb', 'phpdoc' },
--   highlight = {
--     enable = true,
--     disable = {
--       'lua',
--       -- 'vim',
--       'toml',
--       -- 'fish',
--     },
--     additional_vim_regex_highlighting = false,
--   },
--   incremental_selection = {
--     enable = true,
--   },
--   indent = {
--     enable = false,
--   },
--   -- tree_setter = {
--   --   enable = true,
--   -- },
--   -- JoosepAlviste/nvim-ts-context-commentstring
--   context_commentstring = {
--     enable = true,
--   },
--   -- p00f/nvim-ts-rainbow
--   rainbow = {
--     enable = true,
--     exteded_mode = true,
--     max_file_lines = 10000,
--   },
-- })
