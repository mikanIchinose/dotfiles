local map = vim.keymap.set

---@param args string[]
---@return function
local function Ddu(args)
  return function()
    vim.cmd('Ddu ' .. table.concat(args, ' '))
  end
end

map(
  'n',
  '<Leader>ff',
  Ddu({
    '-name=files',
    '-ui-param-startFilter',
    'file_rec',
  }),
  { desc = 'file' }
)
map(
  'n',
  '<Leader>fb',
  Ddu({
    '-name=buffers',
    'buffer',
  }),
  { desc = 'buffer' }
)
map(
  'n',
  '<M-p>',
  Ddu({
    '-name=buffers',
    'buffer',
  }),
  { desc = 'buffer' }
)
map(
  'n',
  '<Leader>fr',
  Ddu({
    '-name=rg',
    "-source-param-input=`input('Pattern: ')`",
    'rg',
  }),
  { desc = 'grep' }
)
map(
  'n',
  '<Leader>fh',
  Ddu({
    '-name=help',
    '-ui-param-startFilter',
    'help',
  }),
  { desc = 'help' }
)
map(
  'n',
  '<C-S-p>',
  Ddu({
    '-name=source',
    '-ui-param-startFilter',
    'source',
  }),
  { desc = 'source' }
)

vim.cmd([[
autocmd FileType markdown
\ nnoremap <buffer> <Leader>fm <Cmd>Ddu
\   -name=outline
\   -resume
\   -ui=filer
\   -ui-param-sort=none
\   -ui-param-sortDirectoriesFirst=v:false
\   -ui-option-persist=v:true
\   markdown
\   <CR>
]])

map(
  'n',
  '?',
  Ddu({
    '-name=search_line',
    -- '-ui-option-persist=v:true',
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

-- like vscode
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
