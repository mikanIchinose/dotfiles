local Hydra = require('hydra')
-- local cmd = require('hydra.keymap-util').cmd

local hint = [[
  ^ ^        Options
  ^
  _v_ %{ve} virtual edit
  _i_ %{list} invisible characters  
  _s_ %{spell} spell
  _S_ %{signcolumn} signcolumn
  _w_ %{wrap} wrap
  _c_ %{cul} cursor line
  _n_ %{nu} number
  _r_ %{rnu} relative number
  ^
       ^^^^                _<Esc>_
]]

Hydra({
  name = 'Options',
  hint = hint,
  config = {
    color = 'amaranth',
    invoke_on_body = true,
    hint = {
      border = 'rounded',
      position = 'middle',
      funcs = {
        signcolumn = function()
          if vim.o.signcolumn == 'yes' then
            return '[x]'
          else
            return '[ ]'
          end
        end,
      }
    }
  },
  mode = { 'n', 'x' },
  body = '<leader>o',
  heads = {
    { 'n', function()
      if vim.o.number == true then
        vim.o.number = false
      else
        vim.o.number = true
      end
    end, { desc = 'number' } },
    { 'r', function()
      if vim.o.relativenumber == true then
        vim.o.relativenumber = false
      else
        vim.o.number = true
        vim.o.relativenumber = true
      end
    end, { desc = 'relativenumber' } },
    { 'v', function()
      if vim.o.virtualedit == 'all' then
        vim.o.virtualedit = 'block'
      else
        vim.o.virtualedit = 'all'
      end
    end, { desc = 'virtualedit' } },
    { 'i', function()
      if vim.o.list == true then
        vim.o.list = false
      else
        vim.o.list = true
      end
    end, { desc = 'show invisible' } },
    { 's', function()
      if vim.o.spell == true then
        vim.o.spell = false
      else
        vim.o.spell = true
      end
    end, { exit = true, desc = 'spell' } },
    {
      'S', function()
        if vim.o.signcolumn == 'yes' then
          vim.o.signcolumn = 'no'
        else
          vim.o.signcolumn = 'yes'
        end
      end, { desc = 'signcolumn' }
    },
    { 'w', function()
      if vim.o.wrap ~= true then
        vim.o.wrap = true
        vim.keymap.set('n', 'k', function()
          return vim.v.count > 0 and 'k' or 'gk'
        end, { expr = true, desc = 'k or gk' })
        vim.keymap.set('n', 'j', function()
          return vim.v.count > 0 and 'j' or 'gj'
        end, { expr = true, desc = 'j or gj' })
      else
        vim.o.wrap = false

        -- 空のマッピングをしてから消す
        vim.keymap.set('n', 'k', function() end)
        vim.keymap.set('n', 'j', function() end)
        vim.keymap.del('n', 'k')
        vim.keymap.del('n', 'j')
      end
    end, { desc = 'wrap' } },
    { 'c', function()
      if vim.o.cursorline == true then
        vim.o.cursorline = false
      else
        vim.o.cursorline = true
      end
    end, { desc = 'cursor line' } },
    { '<Esc>', nil, { exit = true } }
  }
})
