require('gitsigns').setup {
  signs = {
    add          = { text = '樂', },
    -- change = { text = 'm ', },
    delete       = { text = '- ', },
    topdelete    = { text = '- ', },
    changedelete = { text = '- ', },
  },
  -- current_line_blame = true,
  -- current_line_blame_opts = {
  --   virt_text = true,
  --   virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
  --   virt_text_priority = 1,
  --   delay = 10,
  --   ignore_whitespace = false,
  -- },
  current_line_blame_formatter_opts = {
    relative_time = false
  },
}
