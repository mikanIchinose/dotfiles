local conditions = require('heirline.conditions')
local utils = require('heirline.utils')

local Align = { provider = '%=' }
local Space = { provider = ' ' }
local Bar = { provider = '|' }
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
    -- return ' %2(' .. self.mode_names[self.mode] .. '%)'
    return self.mode_names[self.mode]
  end,
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = self.mode_colors[mode], bold = true }
  end,
  update = {
    'ModeChanged',
  },
}
-- local WorkDir = {
--   provider = function(self)
--     self.icon = ' '
--     local cwd = vim.fn.getcwd(0)
--     self.cwd = vim.fn.fnamemodify(cwd, ':~')
--   end,
--   hl = { fg = 'gray', bold = true },
--
--   utils.make_flexible_component(1, {
--     -- evaluates to the full-lenth path
--     provider = function(self)
--       local trail = self.cwd:sub(-1) == '/' and '' or '/'
--       return self.icon .. self.cwd .. trail .. ' '
--     end,
--   }, {
--     -- evaluates to the shortened path
--     provider = function(self)
--       local cwd = vim.fn.pathshorten(self.cwd)
--       local trail = self.cwd:sub(-1) == '/' and '' or '/'
--       return self.icon .. cwd .. trail .. ' '
--     end,
--   }, {
--     -- evaluates to "", hiding the component
--     provider = '',
--   }),
-- }
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

local Modified = {
  condition = function()
    return vim.bo.modified
  end,
  provider = '[+]',
  hl = { fg = 'green' },
}
local ReadOnly = {
  condition = function()
    return not vim.bo.modifiable or vim.bo.readonly
  end,
  provider = '',
  hl = { fg = 'orange' },
}
local FileInfo = {
  {
    condition = function()
      return Modified.condition() or ReadOnly.condition()
    end,
    provider = ' ',
  },
  Modified,
  ReadOnly,
}

-- local isLspAttached = function()
--   if #vim.lsp.buf_get_clients() > 0 then
--     return true
--   else
--     return false
--   end
-- end
local getLspAttachedCurrentBuffer = function()
  -- if #vim.lsp.buf_get_clients() > 0 then
  local active_clients = {}
  for _, value in pairs(vim.lsp.buf_get_clients()) do
    table.insert(active_clients, value.name)
  end
  return string.format('%s %s', require('codicons').get('server', 'icon'), table.concat(active_clients, ' '))
  -- end
  -- return ''
end
local LSPServers = {
  -- condition = isLspAttached,
  update = { 'LspAttach', 'LspDetach', 'BufEnter' },
  provider = getLspAttachedCurrentBuffer,
  -- hl = { fg = '#0f111b', bold = true },
  hl = { fg = '#5ccc96', bold = true },
}
-- LSPServers = utils.surround({ '', '' }, '#5ccc96', { LSPServers })
-- LSPServers[1].condition = isLspAttached
-- LSPServers[3].condition = isLspAttached

local is_ready_navic, navic = pcall(require, 'nvim-navic')
local Navic = {
  condition = function()
    if is_ready_navic then
      return navic.is_available() and navic.get_location() ~= ''
    end
    return false
  end,
  provider = function()
    if is_ready_navic then
      return navic.get_location()
    end
    return 'Navic'
  end,
  hl = { fg = 'gray' },
}
local Git = {
  update = { 'InsertEnter', 'CursorHold' },
  condition = function()
    return vim.g.loaded_gin and vim.g.loaded_gitbranch
  end,
  provider = function()
    -- local gitsigns_ok, _ = pcall(require, 'gitsigns')
    -- if gitsigns_ok then
    --   return vim.b.gitsigns_status
    -- end
    local status_txt = {}
    table.insert(status_txt, '')
    if vim.g.loaded_gitbranch == 1 then
      local branch = vim.fn['gitbranch#name']()
      if branch ~= '' then
        table.insert(status_txt, branch)
      end
    end
    if vim.g.loaded_gin == 1 then
      -- local branch = vim.fn['gin#component#branch#unicode']()
      -- if branch then
      --   table.insert(status_txt, branch)
      -- end
      local traffic = vim.fn['gin#component#traffic#ascii']()
      if traffic ~= '' then
        table.insert(status_txt, traffic)
      end
      local worktree = vim.fn['gin#component#worktree#name']()
      if worktree ~= '' then
        table.insert(status_txt, worktree)
      end
    end
    return table.concat(status_txt, ' ')
    -- if vim.g.loaded_gina == 1 then
    --   local status = ''
    --   local branch = vim.call('gina#component#repo#branch')
    --   if branch == '' then
    --     return ''
    --   end
    --   status = status .. ' ' .. branch
    --   local staged = vim.call('gina#component#status#staged')
    --   if staged ~= '' then
    --     status = status .. string.format('  %s', staged)
    --   end
    --   local unstaged = vim.call('gina#component#status#unstaged')
    --   if unstaged ~= '' then
    --     status = status .. string.format('  %s', unstaged)
    --   end
    --   -- local conflicted = vim.call('gina#component#status#conflicted')
    --   -- local ahead = vim.call('gina#component#status#ahead')
    --   -- local behind = vim.call('gina#component#status#behind')
    --   return status
    -- end
  end,
  hl = { fg = '#ffffff' },
}
local Skk = {
  Space,
  -- condition = vim.g.loaded_skkeleton,
  provider = function(self)
    if vim.g.loaded_skkeleton then
      local mode = vim.fn.mode(1)
      if mode == 'i' or mode == 'c' then
        local skkeleton_mode = vim.fn['skkeleton#mode']()
        if self.mode_names[skkeleton_mode] then
          return ' ' .. self.mode_names[skkeleton_mode]
        else
          return ' A'
        end
      end
    end
    return ' A'
  end,
  static = {
    mode_names = {
      hira = 'あ',
      kata = 'ア',
      hankata = 'ｱ',
      zenkaku = 'Ａ',
      abbrev = 'abbr',
    },
  },
}
local LineInfo = {
  provider = '%7(%l/%3L%):%2c',
  hl = { fg = '#00a3cc' },
}
local FileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}
local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. ' ')
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}
local FileName = {
  provider = function(self)
    local filename = vim.fn.fnamemodify(self.filename, ':.')
    if filename == '' then
      return '[No Name]'
    end
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
}
local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = 'cyan', bold = true, force = true }
    end
  end,
}
FileNameBlock = utils.insert(
  FileNameBlock,
  FileIcon,
  utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
  -- unpack(FileFlags), -- A small optimisation, since their parent does nothing
  { provider = '%<' } -- this means that the statusline is cut here when there's not enough space
)
-- local DeinPluginStatus = {
--   provider = function()
--     local message = 'nvim-lspconfig is'
--     local available = vim.fn['dein#is_available']('nvim-lspconfig') ~= 0
--     if available then
--       message = message .. ' available'
--     else
--       message = message .. ' disablable'
--     end
--     local sourced = vim.fn['dein#is_sourced']('nvim-lspconfig') ~= 0
--     if sourced then
--       message = message .. ' sourced'
--     else
--       message = message .. ' not-sourced'
--     end
--     local tap = vim.fn['dein#tap']('nvim-lspconfig') ~= 0
--     if tap then
--       message = message .. ' tap'
--     else
--       message = message .. ' not-tap'
--     end
--     return message
--   end,
-- }
local statusline = {
  utils.surround({ '', '' }, '#003404', {
    ViMode,
    Skk,
    FileNameBlock,
    FileInfo,
  }),
  Space,
  -- Navic,
  -- Space,
  Align,
  LSPServers,
  -- WorkDir,
  Space,
  Git,
  Space,
  LineInfo,
  hl = { bg = '' },
}

require('heirline').setup({statusline = statusline})
