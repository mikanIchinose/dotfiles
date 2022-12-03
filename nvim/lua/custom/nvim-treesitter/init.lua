local config = {
  ensure_installed = 'all',
  ignore_install = { 'rnoweb', 'phpdoc' },
  highlight = {
    enable = true,
    disable = {
      'lua',
      'toml',
      -- 'vim',
      --'typescript',
      --'typescriptreact',
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
if ts_comment_string_ok then
  config.context_commentstring = {
    enable = true,
  }
end

local ts_rainbow_ok, _ = pcall(require, 'rainbow')
if ts_rainbow_ok then
  config.rainbow = {
    enable = true,
    exteded_mode = true,
    max_file_lines = 10000,
  }
end

local autotag_ok, _ = pcall(require, 'nvim-ts-autotag')
if autotag_ok then
  config.autotag = {
    enable = true,
  }
end

require('nvim-treesitter.configs').setup(config)

local parser_mapping = require('nvim-treesitter.parsers').filetype_to_parsername
parser_mapping.xml = 'html'
