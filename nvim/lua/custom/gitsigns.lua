require('gitsigns').setup({
  signs = {
    add = { text = '樂' },
    change = { text = 'm ' },
    delete = { text = 'x' },
    topdelete = { text = '- ' },
    changedelete = { text = '- ' },
  },
  -- current_line_blame = true,
  -- current_line_blame_opts = {
  --   virt_text = true,
  --   virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
  --   virt_text_priority = 1,
  --   delay = 10,
  --   ignore_whitespace = false,
  -- },
  -- status_formatter = function(status)
  --   local head, added, changed, removed = status.head, status.added, status.changed, status.removed
  --   local status_txt = {}
  --   if head ~= '' then
  --     table.insert(status_txt, head)
  --   end
  --   if added and added > 0 then
  --     table.insert(status_txt, '+' .. added)
  --   end
  --   if changed and changed > 0 then
  --     table.insert(status_txt, '~' .. changed)
  --   end
  --   if removed and removed > 0 then
  --     table.insert(status_txt, '-' .. removed)
  --   end
  --   return table.concat(status_txt, ' ')
  -- end,
  -- current_line_blame_formatter_opts = {
  --   relative_time = false,
  -- },
})
