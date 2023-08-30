local telescope = require 'telescope'
-- local builtin = require 'telescope.builtin'
-- local themes = require 'telescope.themes'
-- local fb = telescope.extensions.file_browser

telescope.setup {
  defaults = {
    layout_strategy = 'bottom_pane',
    layout_config = {
      height = 0.6,
    },
    sorting_strategy = 'ascending',
  },
  pickers = {
    find_files = {
      prompt_prefix = 'File> '
    },
    buffers = {
      prompt_prefix = 'Buffer> '
    },
    commands = {
      prompt_prefix = 'Command> '
    },
    file_browser = {
      prompt_prefix = 'Browse> '
    },
    live_grep = {
      prompt_prefix = 'Grep> '
    },
  },
  extensions = {
    -- file_browser = {
    --   theme = 'bottom_pane',
    -- }
  },
}

telescope.load_extension('project')
telescope.load_extension('file_browser')
telescope.load_extension('notify')
