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
      a = {
        --   Ddu {
        --     'custom-list',
        --   },
        --   'custom list'
        Ddu {
          '-name=readme',
          '-ui-param-startFilter',
          'readme_viewer',
        },
        'readme'
      },
      f = {
        Ddu {
          '-name=files',
          '-ui-param-startFilter',
          'file_rec',
        },
        'find file'
      },
      F = {
        Ddu {
          '-name=filer',
          '-ui=filer',
          'file',
          '-source-option-columns=icon_filename',
          '-source-option-path=`getcwd()`',
          'buffer',
        },
        'filer'
      },
      b = {
        Ddu {
          '-name=buffers',
          'buffer',
        },
        'find buffer'
      },
      r = {
        Ddu {
          '-name=search_source',
          [[-source-param-input=`input('Pattern: ')`]],
          'rg',
        },
        'find source'
      },
      d = {
        Ddu {
          '-name=dein',
          '-ui-param-startFilter',
          'dein',
        },
        'dein'
      },
      h = {
        Ddu {
          '-name=help',
          '-ui-param-startFilter',
          'help',
        },
        'find help'
      },
      m = {
        Ddu {
          '-name=mr',
          'mr',
        },
        'find mr'
      },
      c = {
        Ddu {
          '-name=commands',
          '-ui-param-startFilter',
          'command_history',
        },
        'find command'
      },
      C = {
        Ddu {
          '-name=color',
          'colorscheme',
        },
        'find color'
      },
    },
  }
})

vim.cmd [[
" nnoremap <silent> / <Cmd>Ddu
"\ -name=search line
"\ -ui-param-startFilter<CR>
" nnoremap <silent> * <Cmd>Ddu
"\ -name=search line 
"\ -input=`expand('<cword>')`
"\ -ui-param-startFilter=v:false<CR>
]]
map('n', '/', Ddu {
  '-name=search_line',
  '-ui-param-startFilter',
  'line',
}, { silent = true })
map('i', '<C-x><C-e>', Ddu {
  '-name=emoji',
  'emoji',
})
