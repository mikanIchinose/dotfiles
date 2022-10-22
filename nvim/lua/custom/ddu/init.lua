local patch_global = {}

local sourceOptions = {
  _ = {
    ignoreCase = true,
    matchers = {
      -- 'converter_display_word',
      -- 'matcher_relative',
      -- 'matcher_fzf',
      'matcher_substring',
    },
    -- converters = {
    --   -- 'converter_display_word',
    -- },
  },
  buffer = {
    -- converters = {
    --   'converter_display_word',
    -- },
  },
  file = {
    -- columns = {
    --   'icon_filename'
    -- },
    matchers = {
      'matcher_hidden', -- ignore hidden file
    },
  },
  file_rec = {
    -- columns = {
    --   'filename'
    -- },
    -- converters = {
    --   'matcher_substring',
    -- },
  },
  file_old = {
    -- columns = {
    --   'icon_filename'
    -- },
  },
  line = {},
  rg = {
    matchers = {
      -- 'converter_display_word',
      'matcher_substring',
      'matcher_hidden',
    },
    -- converters = {
    --   'converter_display_word',
    -- 'matcher_substring',
    -- },
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
}

local sourceParams = {
  file_rec = {
    ignoredDirectories = {
      '.git',
      'node_modules',
    },
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
  -- ['custom-list'] = {
  --   texts = { 'a', 'b', 'c' }
  -- },
}

local filterParams = {
  matcher_fzf = {
    highlightMatched = 'Search',
  },
  matcher_substring = {
    highlightMatched = 'Search',
  },
}

local uiOptions = {
  filer = {
    toggle = false,
  },
}

---@class DduUiFiler_UiParam
---@field split 'horizontal'|'vertical'|'floating'|'no'
---@field focus boolean
---@field sort 'extention'|'filename'|'size'|'time'
---@field sortDirectoriesFirs boolean

---@type DduUiFiler_UiParam
local filerVertical = {
  toggle = false,
  split = 'vertical',
  splitDirection = 'topleft',
  winWidth = 30,
}
---@type DduUiFiler_UiParam
local filerNoSplit = {
  toggle = true,
  split = 'no',
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
  filer = filerNoSplit,
}

local kindOptions = {
  file = { defaultAction = 'open' },
  word = { defaultAction = 'append' },
  action = { defaultAction = 'do' },
  deol = { defaultAction = 'switch' },
  help = { defaultAction = 'open' },
  command_history = { defaultAction = 'execute' },
  colorscheme = { defaultAction = 'set' },
  source = { defaultAction = 'execute' },
  readme_viewer = { defaultAction = 'open' },
  dein_update = { defaultAction = 'viewDiff' },
}

local actionOptions = {
  -- _ = { quit = false },
  bdelete = { quit = false },
  delete = { quit = false },
  getSourceName = { quit = false },
  set = { quit = false },
  echo = { quit = false },
  echoDiff = { quit = false },
  viewDiff = { quit = false },
}

local columnOptions = {}

local columnParams = {
  icon_filename = {
    defaultIcon = {
      icon = '',
    },
  },
}

patch_global.ui = 'ff'
patch_global.sourceOptions = sourceOptions
patch_global.sourceParams = sourceParams
patch_global.filterParams = filterParams
patch_global.uiOptions = uiOptions
patch_global.uiParams = uiParams
patch_global.kindOptions = kindOptions
patch_global.actionOptions = actionOptions
patch_global.compilerOptions = columnOptions
patch_global.columnParams = columnParams
vim.call('ddu#custom#patch_global', patch_global)
