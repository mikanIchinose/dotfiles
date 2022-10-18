local map = vim.keymap.set
local opts = { silent = true, expr = true }

vim.cmd([[
inoremap <silent><expr> <TAB>
 \ ddc#map#pum_visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
 \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
 \ '<TAB>' : ddc#manual_complete()
]])
vim.cmd([[
cnoremap <expr> <Tab>
\ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
\ exists('b:ddc_cmdline_completion') ?
\ ddc#manual_complete() : nr2char(&wildcharm)
cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
cnoremap <C-c>   <Cmd>call pum#map#cancel()<CR>
cnoremap <C-o>   <Cmd>call pum#map#confirm()<CR>

]])
map('i', '<S-TAB>', function()
  if vim.call('ddc#map#pum_visible') ~= 0 then
    return [[<Cmd>call pum#map#insert_relative(-1)<CR>]]
  else
    return [[\<S-TAB>]]
  end
end, opts)
map('i', '<C-y>', function()
  vim.call('pum#map#confirm')
end)
map('i', '<C-e>', function()
  vim.call('pum#map#cancel')
end)
map('i', '<C-Space>', function()
  vim.call('ddc#map#manual_complete')
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
  if vim.call('vsnip#jumpable', 1) ~= 0 then
    return '<Plug>(vsnip-jump-next)'
  else
    return '<Plug>(skkeleton-toggle)'
  end
end, { expr = true })
map('i', '<C-k>', function()
  if vim.call('vsnip#jumpable', -1) ~= 0 then
    return '<Plug>(vsnip-jump-prev)'
  else
    return '<C-k>'
  end
end, { expr = true })
