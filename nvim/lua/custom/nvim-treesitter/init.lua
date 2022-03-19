require'nvim-treesitter.configs'.setup {
    ensure_installed = {
      -- shell
      'bash', 'fish',
      -- JVM
      'java', 'kotlin',
      -- Web
      'html', 'pug',
      'javascript', 'jsdoc', 'typescript','tsx', 'vue',
      -- setting files
      'json', 'json5', 'jsonc', 'yaml', 'toml',
      -- vim
      'vim', 'lua',
      -- other language
      'commonlisp',
      'dart',
      'go',
      'php',
      'python',
      'rust',
      -- other type
      'markdown',
      'comment',
      'http',
      'graphql',
    },
    highlight = {
        enable = true,
        disable = {
          -- 'lua',
          'vim',
          'fish',
        },
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
    },
    -- rainbow = {
    --   enable = true,
    --   disable = {'markdown'},
    --   exteded_mode = true,
    --   max_file_lines = nil,
    -- },
    -- indent = {
      -- enable = false,
    -- }
}
