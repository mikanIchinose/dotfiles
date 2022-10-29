local map = vim.keymap.set

---@param args string[]
---@return function
local function Ddu(args)
  return function()
    vim.cmd('Ddu ' .. table.concat(args, ' '))
  end
end

require('which-key').register({
  ['<Leader>'] = {
    f = {
      name = '+find',
      -- a = {
      --   --   Ddu {
      --   --     'custom-list',
      --   --   },
      --   --   'custom list'
      --   Ddu({
      --     '-name=readme',
      --     '-ui-param-startFilter',
      --     'readme_viewer',
      --   }),
      --   'readme',
      -- },
      f = {
        Ddu({
          '-name=files',
          '-ui-param-startFilter',
          'file_rec',
        }),
        'find file',
      },
      F = {
        Ddu({
          '-name=filer',
          '-resume',
          '-ui=filer',
          'file',
          '-source-option-columns=icon_filename',
          '-source-option-path=`getcwd()`',
          -- 'buffer',
        }),
        'filer',
      },
      b = {
        Ddu({
          '-name=buffers',
          'buffer',
        }),
        'find buffer',
      },
      r = {
        Ddu({
          '-name=search_source',
          [[-source-param-input=`input('Pattern: ')`]],
          'rg',
        }),
        'find source',
      },
      d = {
        Ddu({
          '-name=dein',
          '-ui-param-startFilter',
          'dein',
        }),
        'dein',
      },
      h = {
        Ddu({
          '-name=help',
          '-ui-param-startFilter',
          'help',
        }),
        'find help',
      },
      c = {
        Ddu({
          '-name=commands',
          '-ui-param-startFilter',
          'command_history',
        }),
        'find command',
      },
      C = {
        Ddu({
          '-name=color',
          'colorscheme',
        }),
        'find color',
      },
    },
  },
})

vim.cmd([[
autocmd FileType markdown
\ nnoremap <buffer> <Leader>fm <Cmd>Ddu
\   -name=headers
\   -resume
\   -ui=filer
\   -ui-param-sort=size
\   markdown
\   <CR>
]])

map(
  'n',
  '/',
  Ddu({
    '-name=search_line',
    '-ui-param-startFilter',
    'line',
  }),
  { silent = true }
)
map(
  'i',
  '<C-x><C-e>',
  Ddu({
    '-name=emoji',
    'emoji',
  })
)
map('n', '<C-p>', function()
  vim.fn['ddu#start']({
    sources = {
      { name = 'file_rec' },
    },
    ui = 'ff',
    uiParams = {
      ff = {
        prompt = '> ',
        startFilter = true,
        statusline = false,
        split = 'floating',
        floatingBorder = 'rounded',
      },
    },
  })
end)
-- map('n', '<Leader>fm', function()
--   vim.fn['ddu#start']({
--     sources = {
--       { name = 'markdown' },
--     },
--     -- ui = 'filer',
--     -- uiParams = {
--     --   filer = {
--     --     split = 'vertical',
--     --     sort = 'size',
--     --   },
--     -- },
--     actionOptions = {
--       open = { quit = false },
--     },
--   })
-- end)
