local conditions = require('heirline.conditions')
local utils = require('heirline.utils')

local ViMode = {
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
    if not self.once then
      vim.api.nvim_create_autocmd('ModeChanged', {
        pattern = '*:*o',
        command = 'redrawstatus',
      })
      self.once = true
    end
  end,
  static = {
    mode_names = { -- change the strings if you like it vvvvverbose!
      n = 'N',
      no = 'N?',
      nov = 'N?',
      noV = 'N?',
      ['no\22'] = 'N?',
      niI = 'Ni',
      niR = 'Nr',
      niV = 'Nv',
      nt = 'Nt',
      v = 'V',
      vs = 'Vs',
      V = 'V_',
      Vs = 'Vs',
      ['\22'] = '^V',
      ['\22s'] = '^V',
      s = 'S',
      S = 'S_',
      ['\19'] = '^S',
      i = 'I',
      ic = 'Ic',
      ix = 'Ix',
      R = 'R',
      Rc = 'Rc',
      Rx = 'Rx',
      Rv = 'Rv',
      Rvc = 'Rv',
      Rvx = 'Rv',
      c = 'C',
      cv = 'Ex',
      r = '...',
      rm = 'M',
      ['r?'] = '?',
      ['!'] = '!',
      t = 'T',
    },
    mode_colors = {
      n = 'red',
      i = 'green',
      v = 'cyan',
      V = 'cyan',
      ['\22'] = 'cyan',
      c = 'orange',
      s = 'purple',
      S = 'purple',
      ['\19'] = 'purple',
      R = 'orange',
      r = 'orange',
      ['!'] = 'red',
      t = 'red',
    },
  },
  provider = function(self)
    return ' %2(' .. self.mode_names[self.mode] .. '%)'
  end,
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = self.mode_colors[mode], bold = true }
  end,
  update = {
    'ModeChanged',
  },
}
local WorkDir = {
  provider = function(self)
    self.icon = (vim.fn.haslocaldir(0) == 1 and 'l' or 'g') .. ' ' .. ' '
    local cwd = vim.fn.getcwd(0)
    self.cwd = vim.fn.fnamemodify(cwd, ':~')
  end,
  hl = { fg = 'gray', bold = true },

  utils.make_flexible_component(1, {
    -- evaluates to the full-lenth path
    provider = function(self)
      local trail = self.cwd:sub(-1) == '/' and '' or '/'
      return self.icon .. self.cwd .. trail .. ' '
    end,
  }, {
    -- evaluates to the shortened path
    provider = function(self)
      local cwd = vim.fn.pathshorten(self.cwd)
      local trail = self.cwd:sub(-1) == '/' and '' or '/'
      return self.icon .. cwd .. trail .. ' '
    end,
  }, {
    -- evaluates to "", hiding the component
    provider = '',
  }),
}
local FileName = {
  provider = function(self)
    -- first, trim the pattern relative to the current directory. For other
    -- options, see :h filename-modifers
    local filename = vim.fn.fnamemodify(self.filename, ':.')
    if filename == '' then
      return '[No Name]'
    end
    -- now, if the filename would occupy more than 1/4th of the available
    -- space, we trim the file path to its initials
    -- See Flexible Components section below for dynamic truncation
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = { fg = utils.get_highlight('Directory').fg },
}
local LSPServers = {
  condition = conditions.lsp_attached,
  update = { 'LspAttach', 'LspDetach' },
  provider = function(self)
    if #vim.lsp.buf_get_clients() > 0 then
      local active_clients = {}
      for _, value in pairs(vim.lsp.buf_get_clients()) do
        table.insert(active_clients, value.name)
      end
      return string.format('%s %s', require('codicons').get('server', 'icon'), table.concat(active_clients, ' '))
    end
    return ''
  end,
  hl = { fg = '#0f111b', bold = true },
}
local is_ready_navic, navic = pcall(require, 'nvim-navic')
local Navic = {
  condition = function()
    if is_ready_navic then
      return navic.is_available() and navic.get_location() ~= ''
    end
    return false
  end,
  provider = function(self)
    if is_ready_navic then
      return navic.get_location()
    end
    return 'Navic'
  end,
  hl = { fg = 'gray' },
}
local Git = {
  condition = function()
    return vim.g.loaded_gina == 1
  end,
  provider = function(self)
    if vim.g.loaded_gina == 1 then
      local status = ''
      local branch = vim.call('gina#component#repo#branch')
      if branch == '' then
        return ''
      end
      status = status .. ' ' .. branch
      local staged = vim.call('gina#component#status#staged')
      if staged ~= '' then
        status = status .. string.format('  %s', staged)
      end
      local unstaged = vim.call('gina#component#status#unstaged')
      if unstaged ~= '' then
        status = status .. string.format('  %s', unstaged)
      end
      -- local conflicted = vim.call('gina#component#status#conflicted')
      -- local ahead = vim.call('gina#component#status#ahead')
      -- local behind = vim.call('gina#component#status#behind')
      return status
    end
    -- if vim.g.loaded_gin == 1 then
    --   return 'Gin ' .. vim.call('gin#component#branch#unicode')
    -- end
    return ''
  end,
  hl = { fg = '#ce6f8f' },
}
local LineInfo = {
  provider = '%7(%l/%3L%):%2c',
  hl = { fg = '#00a3cc' },
}
local Align = { provider = '%=' }
local Space = { provider = ' ' }
ViMode = utils.surround({ '', '' }, '#30365F', { ViMode })
LSPServers = utils.surround({ '', '' }, '#5ccc96', { LSPServers })
-- LineInfo = utils.surround({ '', '' }, '#5ccc96', { LineInfo })
-- Git = utils.surround({ '', '' }, '#30365F', { Git })
local statusline = {
  ViMode,
  Space,
  LSPServers,
  Space,
  Navic,
  Align,
  WorkDir,
  Space,
  Git,
  Space,
  LineInfo,
}

require('heirline').setup(statusline)