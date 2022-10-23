local map = vim.keymap.set
local opts = { silent = true, expr = true }

local pum_visible = function()
  if vim.fn['ddc#custom#get_global']().ui == 'pum' then
    vim.fn['pum#visible']()
  else
    vim.fn.pumvisible()
  end
end

vim.cmd([[
inoremap <silent><expr> <TAB>
 \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
 \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
 \ '<TAB>' : ddc#manual_complete()
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
    vim.fn['pum#map#insert_relative']('-1')
  else
    return [[\<S-TAB>]]
  end
end, opts)
map('i', '<C-y>', function()
  vim.fn['pum#map#confirm']()
end)
map('i', '<C-e>', function()
  vim.fn['pum#map#cancel']()
end)
map('i', '<C-Space>', function()
  vim.fn['ddc#map#manual_complete']()
end)
map('c', '<Tab>', function()
  if pum_visible() ~= 0 then
    vim.fn['pum#map#insert_relative']('+1')
  elseif vim.fn.exists('b:ddc_cmdline_completion') ~= 0 then
    vim.fn['ddc#manual_complete']()
  else
    vim.fn.nr2char(vim.o.wildcharm)
  end
end)
map('c', '<S-Tab>', function()
  vim.fn['pum#map#insert_relative']('-1')
end)
map('c', '<C-c>', function()
  vim.fn['pum#map#cancel']()
end)
map('c', '<C-o>', function()
  vim.fn['pum#map#confirm']()
end)

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
