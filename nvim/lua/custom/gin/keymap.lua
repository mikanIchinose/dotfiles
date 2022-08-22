require('which-key').register({
  ['<Leader>'] = {
    g = {
      name = '+git',
      b = { '<Cmd>GinBranch -a<CR>', 'GinBranch' },
      -- B = { '<Cmd>GinBuffer<CR>', 'GinBuffer' },
      c = { '<Cmd>GinChaperon<CR>', 'GinChaperon' },
      d = { '<Cmd>GinDiff ++processor=delta<CR>', 'GinDiff' },
      -- e = { '<Cmd>GinEdit<CR>', 'GinEdit' },
      s = { '<Cmd>GinStatus<CR>', 'GinStatus' },
    }
  }
})
