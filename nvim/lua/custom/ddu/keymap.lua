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
      f = {
        Ddu({
          '-name=files',
          '-ui-param-startFilter',
          'file_rec',
        }),
        'file',
      },
      F = {
        Ddu({
          '-name=filer',
          '-resume',
          '-ui=filer',
          '-ui-param-split=no',
          'file',
          '-source-option-columns=icon_filename',
          '-source-option-path=`getcwd()`',
        }),
        'filer',
      },
      b = {
        Ddu({
          '-name=buffers',
          'buffer',
        }),
        'buffer',
      },
      r = {
        Ddu({
          '-name=search_source',
          "-source-param-input=`input('Pattern: ')`",
          'rg',
        }),
        'source',
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
        'help',
      },
      c = {
        Ddu({
          '-name=commands',
          '-ui-param-startFilter',
          'command_history',
        }),
        'command',
      },
      C = {
        Ddu({
          '-name=color',
          'colorscheme',
        }),
        'color',
      },
      m = {
        function()
          vim.fn['ddu#start']({
            sources = {
              { name = 'markdown' },
            },
            ui = 'filer',
            uiParams = {
              filer = {
                sort = 'none',
              },
            },
            actionOptions = {
              open = { quit = false },
            },
          })
        end,
        'outline',
      },
    },
  },
})

-- vim.cmd([[
-- autocmd FileType markdown
-- \ nnoremap <buffer> <Leader>fm <Cmd>Ddu
-- \   -name=headers
-- \   -resume
-- \   -ui=filer
-- \   -ui-param-sort=size
-- \   -ui-param-sortDirectoriesFirst=v:false
-- \   markdown
-- \   -source-option-columns=tree
-- \   <CR>
-- ]])

map(
  'n',
  '?',
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
