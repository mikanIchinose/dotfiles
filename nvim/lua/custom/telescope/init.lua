local telescope = require 'telescope'
local builtin = require 'telescope.builtin'
local themes = require 'telescope.themes'

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
--    extensions = {
--    },
}

telescope.load_extension('project')
