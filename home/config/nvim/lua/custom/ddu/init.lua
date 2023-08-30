local patch_global = {}

-- @section source
--- @class DduSouceOption
--- @field matchers string[]
--- @field sorters string[]
--- @field filters string[]
--- @field columns string[]

--- @type table<string, DduSouceOption>
local sourceOptions = {
  _ = {
    ignoreCase = true,
    matchers = {
      'matcher_substring',
    },
  },
  buffer = {},
  file = {
    matchers = {
      'matcher_hidden',
      'matcher_substring',
      'matcher_fzf',
    },
    sorters = {
      'sorter_alpha',
    },
  },
  file_rec = {
    sorters = {
      'sorter_alpha',
    },
  },
  file_old = {
    sorters = {
      'sorter_alpha',
    },
  },
  file_fd = {
    sorters = {
      'sorter_alpha',
    },
  },
  line = {},
  rg = {
    matchers = {
      'matcher_substring',
    },
    sorters = {},
  },
  dein = {
    defaultAction = 'cd',
  },
  dein_update = {
    matchers = {
      'matcher_dein_update',
    },
  },
  markdown = {
    columns = { 'filename' },
    sorters = {}, -- 勝手に並び換えられると困る
  },
  zenn = {
    sorters = {
      'sorter_alpha',
    },
  },
}

local sourceParams = {
  file_rec = {
    ignoredDirectories = {
      '.git',
      '.next',
      'node_modules',
    },
  },
  file_fd = {
    args = { '--max-depth', '20', '--hidden', '--type', 'f' },
  },
  rg = {
    args = {
      '--json',
      '--column',
      '--no-heading',
      '--color',
      'never',
    },
  },
  dein_update = {
    useGraphQL = true,
  },
  markdown = {
    style = 'none',
  },
}

-- @section filter
local filterParams = {
  matcher_fzf = {
    highlightMatched = 'Search',
  },
  matcher_substring = {
    highlightMatched = 'Search',
  },
}

-- @section ui
local uiOptions = {
  filer = {
    -- toggle = false,
    -- persist = true,
  },
}

---@class DduUiFilerUiParam
---@field split 'horizontal'|'vertical'|'floating'|'no'
---@field focus boolean
---@field sort 'extention'|'filename'|'size'|'time'
---@field sortDirectoriesFirs boolean

--- @type table
local filerUiParams = {
  ---@type DduUiFilerUiParam
  vertical = {
    toggle = false,
    split = 'vertical',
    splitDirection = 'topleft',
    winWidth = 30,
  },
  ---@type DduUiFilerUiParam
  horizontal = {
    toggle = false,
    split = 'horizontal',
  },
  ---@type DduUiFilerUiParam
  floating = {
    toggle = false,
    split = 'floating',
  },
  ---@type DduUiFilerUiParam
  noSplit = {
    toggle = true,
    split = 'no',
  },
}

---@class DduUiFfUiParam
---@field split 'horizontal'|'vertical'|'floating'|'no'
---@field focus boolean
---@field sort 'extention'|'filename'|'size'|'time'
---@field sortDirectoriesFirs boolean

local ffUiParams = {
  horizontal = {
    filterSplitDirection = 'floating',
    filterFloatingPosition = 'top',
    split = 'horizontal',
    statusline = false,
  },
  vertical = {},
  floating = {},
  noSplit = {},
}
local ffHorizontal = {
  filterSplitDirection = 'floating',
  filterFloatingPosition = 'top',
  split = 'horizontal',
  statusline = false,
}
local ffFloatingBottom = {
  statusline = false,
  filterSplitDirection = 'floating',
  filterFloatingPosition = 'top',
  split = 'floating',
  splitDirection = 'botright',
  winHeight = 30,
  winWidth = vim.o.columns,
  winCol = 10,
  winRow = vim.o.lines - 30,
  previewFloating = true,
  previewVertical = false,
  previewHeight = 20,
  previewWidth = vim.o.columns / 2,
  previewCol = vim.o.columns,
  previewRow = vim.o.lines,
}
local ffFloatingFloat = {}

local uiParams = {
  ff = {
    -- autoResize = true,
    -- floatingBorder = 'solid',
    -- displaySourceName = 'long',
    filterSplitDirection = 'floating',
    filterFloatingPosition = 'top',
    -- split = 'floating',
    -- splitDirection = 'floating',
    split = 'horizontal',
    -- splitDirection = 'botright',
    -- winHeight = 30,
    -- winWidth = vim.o.columns,
    -- winCol = 10,
    -- winRow = vim.o.lines - 30,
    -- previewFloating = true,
    -- previewVertical = false,
    -- previewHeight = 20,
    -- previewWidth = vim.o.columns / 2,
    -- previewCol = vim.o.columns,
    -- previewRow = vim.o.lines,
    statusline = false,
  },
  filer = filerUiParams.noSplit,
}

-- @section kind
local kindParams = {
  extcmd = {
    runner = 'terminal',
  },
  -- action = {
  --   -- action実行後はdduを閉じる
  --   quit = false,
  -- },
}
local kindOptions = {
  file = { defaultAction = 'open' },
  word = { defaultAction = 'insert' },
  action = { defaultAction = 'do' },
  deol = { defaultAction = 'switch' },
  help = { defaultAction = 'tabopen' },
  command_history = { defaultAction = 'execute' },
  colorscheme = { defaultAction = 'set' },
  source = { defaultAction = 'execute' },
  readme_viewer = { defaultAction = 'open' },
  dein_update = { defaultAction = 'viewDiff' },
  ui_select = { defaultAction = 'select' },
  extcmd = { defaultAction = 'run' },
}

-- @section action
local actionOptions = {
  bdelete = { quit = false },
  delete = { quit = false },
  trash = { quit = false },
  getSourceName = { quit = false },
  set = { quit = false },
  echo = { quit = false },
  echoDiff = { quit = false },
  viewDiff = { quit = false },
}

-- @section column
local columnOptions = vim.empty_dict()
local columnParams = {
  icon_filename = {
    defaultIcon = {
      icon = '',
    },
  },
}

patch_global.sourceOptions = sourceOptions
patch_global.sourceParams = sourceParams
patch_global.filterParams = filterParams
patch_global.ui = 'ff'
patch_global.uiOptions = uiOptions
patch_global.uiParams = uiParams
patch_global.kindParams = kindParams
patch_global.kindOptions = kindOptions
patch_global.actionOptions = actionOptions
patch_global.columnOptions = columnOptions
patch_global.columnParams = columnParams

vim.fn['ddu#custom#patch_global'](patch_global)
