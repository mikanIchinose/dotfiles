local map = vim.keymap.set
local opts = { silent = true, expr = true }

local pum_visible = function()
  if vim.fn['ddc#custom#get_global']().ui == 'pum' then
    vim.fn['pum#visible']()
  else
    vim.fn.pumvisible()
  end
end
local manual_complete = function(options)
  vim.fn['ddc#map#manual_complete'](options)
end
local confirm = function()
  vim.fn['pum#map#confirm']()
end
local cancel = function()
  vim.fn['pum#map#cancel']()
end
local cmp_up = function()
  vim.fn['pum#map#select_relative']('-1')
end
local cmp_down = function()
  vim.fn['pum#map#select_relative']('+1')
end

vim.cmd([[
inoremap <silent><expr> <TAB>
 \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
 \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
 \ '<TAB>' : ddc#map#manual_complete(['nvim-lsp','rg','around'],'pum')
]])
-- map('i', '<TAB>', function()
--   local col = vim.fn.col('.')
--   if vim.fn['ddc#map#pum_visible']() ~= 0 then
--     vim.fn['pum#map#insert_relative']('+1')
--   elseif col <= 1 or vim.fn.getline('.')[col - 2] then
--     return [[\<TAB>]]
--   else
--     vim.fn['ddc#manual_complete']()
--   end
-- end, opts)
map('i', '<S-TAB>', function()
  if pum_visible() ~= 0 then
    cmp_up()
  else
    return [[\<S-TAB>]]
  end
end, opts)
map('i', '<C-y>', function()
  confirm()
end)
map('i', '<C-e>', function()
  cancel()
end)
map('i', '<C-Space>', function()
  manual_complete({ sources = { 'nvim-lsp' } })
end, opts)
--map('c', '<C-Space>', function()
--  manual_complete({ 'cmdline' })
--end, opts)
--map('c', '<Tab>', function()
--  if pum_visible() ~= 0 then
--    cmp_down()
--  elseif vim.fn.exists('b:ddc_cmdline_completion') ~= 0 then
--    manual_complete('cmdline')
--  else
--    vim.fn.nr2char(vim.o.wildcharm)
--  end
--end,{buffer=true})
--map('c', '<S-Tab>', function()
--  cmp_up()
--end)
--map('c', '<C-c>', function()
--  cancel()
--end)
--map('c', '<C-o>', function()
--  confirm()
--end)
vim.cmd([[
cnoremap <expr> <Tab>
\ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
\ exists('b:ddc_cmdline_completion') ?
\ ddc#map#manual_complete() : nr2char(&wildcharm)
cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
cnoremap <C-o>   <Cmd>call pum#map#confirm()<CR>
cnoremap <expr> <C-e>
\ ddc#map#insert_item(0, '<Cmd>call pum#map#cancel()<CR>')
]])

-- snippet
vim.cmd([[
autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)
]])
-- map('i', '<C-i>', function()
--   if vim.call('vsnip#expandable') ~= 0 then
--     return '<Plug>(vsnip-expand)'
--   else
--     return '<C-i>'
--   end
-- end, { expr = true })
-- map('i', '<C-o>', function()
--   if vim.call('vsnip#available', 1) ~= 0 then
--     return '<Plug>(vsnip-expand-or-jump)'
--   else
--     return '<C-o>'
--   end
-- end, { expr = true })
map('i', '<C-j>', function()
  if vim.fn['vsnip#jumpable'](1) ~= 0 then
    return '<Plug>(vsnip-jump-next)'
  else
    return '<Plug>(skkeleton-toggle)'
  end
end, { expr = true })
map('i', '<C-k>', function()
  if vim.fn['vsnip#jumpable'](-1) ~= 0 then
    return '<Plug>(vsnip-jump-prev)'
  else
    return '<C-k>'
  end
end, { expr = true })
