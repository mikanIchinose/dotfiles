---@param option_name string
local function patch_global(option_name, value)
  vim.fn['ddc#custom#patch_global'](option_name, value)
end

---@param filetypes string[]
---@param option_name string
local function patch_filetype_with_option(filetypes, option_name, value)
  vim.fn['ddc#custom#patch_filetype'](filetypes, option_name, value)
end

local function patch_filetype(filetypes, value)
  vim.fn['ddc#custom#patch_filetype'](filetypes, value)
end

patch_global('ui', 'pum')

patch_global('sourceOptions', {
  ['_'] = {
    -- matchers = { 'matcher_head' },
    -- sorters = { 'sorter_rank' },
    -- converters = { 'converter_remove_overlap' },
    --matchers = { 'matcher_head' },
    -- fuzzy maching
    matchers = { 'matcher_fuzzy' },
    sorters = { 'sorter_fuzzy' },
    converters = { 'converter_fuzzy' },
  },
  ['nvim-lsp'] = {
    mark = 'LSP',
    forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
    -- matchers = { 'matcher_fuzzy' },
    -- sorters = { 'sorter_fuzzy' },
    -- converters = { 'converter_fuzzy' },
  },
  ['nvim-lsp_by-treesitter'] = {
    mark = 'LSP_TS',
  },
  treesitter = {
    mark = 'TS',
  },
  necovim = {
    mark = 'vim',
  },
  around = {
    mark = 'Around',
  },
  rg = {
    mark = 'Rg',
    minAutoCompleteLength = 4,
  },
  file = {
    mark = '',
    isVolatile = true,
    forceCompletionPattern = [[\S/\S*]],
  },
  skkeleton = {
    mark = 'skk',
    matchers = { 'skkeleton' },
    sorters = {},
    minAutoCompleteLength = 2,
    isVolatile = true,
  },
  mocword = {
    mark = 'mocword',
    minAutoCompleteLength = 3,
    isVolatile = true,
  },
})
patch_global('sourceParams', {
  file = {
    filenameChars = '[:keyword:].',
    disableMenu = true,
  },
})
local lspkind_ok, _ = pcall(require, 'lspkind')
if lspkind_ok then
  patch_global('sourceParams', {
    ['nvim-lsp'] = {
      kindLabels = require('lspkind').symbol_map,
    },
    ['nvim-lsp_by-treesitter'] = {
      kindLabels = require('lspkind').symbol_map,
    },
  })
end

-- use pum.vim
patch_global('autoCompleteEvents', {
  'InsertEnter',
  'TextChangedI',
  'TextChangedP',
  'TextChangedT',
  'CmdlineEnter',
  'CmdlineChanged',
})

-- set sources
patch_global('sources', { 'nvim-lsp', 'vsnip', 'file', 'mocword', 'around', 'rg' })
patch_global('cmdlineSources', {
  [':'] = { 'cmdline', 'cmdline-history', 'file', 'around' },
  ['@'] = { 'cmdline', 'cmdline-history', 'file', 'around' },
  ['>'] = { 'cmdline', 'cmdline-history', 'file', 'around' },
  ['/'] = { 'cmdline', 'cmdline-history', 'file', 'around' },
  ['?'] = { 'cmdline', 'cmdline-history', 'file', 'around' },
  ['-'] = { 'cmdline', 'cmdline-history', 'file', 'around' },
  ['='] = { 'cmdline', 'cmdline-history', 'file', 'around' },
})
patch_filetype_with_option({ 'toml' }, 'sources', { 'nvim-lsp', 'necovim', 'around', 'file' })
patch_filetype_with_option({ 'vim' }, 'sources', { 'necovim', 'nvim-lsp', 'file', 'around' })
patch_filetype({ 'ddu-ff-filter' }, {
  keywordPattern = '[0-9a-zA-Z_:#-]*',
  sources = { 'line', 'buffer' },
  specialBufferCompletion = true,
})
patch_filetype({ 'FineCmdlinePrompt' }, {
  keywordPattern = '[0-9a-zA-Z_:#-]*',
  sources = { 'cmdline-history', 'file', 'around' },
  specialBufferCompletion = true,
})

-- NOTE: ghost-textで補完するときに必要
-- patch_filetype({ 'markdown' }, 'specialBufferCompletion', 'v:true')
patch_global('specialBufferCompletion', 'v:true')
vim.fn['ddc#enable']()

-- NOTE: lspkindを使うので不要、また必要になったらまた使う
-- local codicon = require('codicons')
-- ---@param identifier string
-- local geticon = function(identifier)
--   return codicon.get(identifier, 'icon')
-- end
--
-- local labels = {
--   Text = "",
--   Method = geticon('symbol-method'),
--   Function = "",
--   Constructor = "",
--   Field = "ﰠ",
--   Variable = geticon('symbol-variable'),
--   Class = geticon('symbol-class'),
--   Interface = "",
--   Module = "",
--   Property = geticon('symbol-property'),
--   Unit = "塞",
--   Value = "",
--   Enum = geticon('symbol-enum'),
--   Keyword = geticon('symbol-keyword'),
--   Snippet = geticon('symbol-snippet'),
--   Color = geticon('symbol-color'),
--   File = "",
--   Reference = "",
--   Folder = "",
--   EnumMember = geticon('symbol-enum-member'),
--   Constant = geticon('symbol-constant'),
--   Struct = geticon('symbol-structure'),
--   Event = geticon('symbol-event'),
--   Operator = geticon('symbol-operator'),
--   TypeParameter = "",
-- }
--
-- for k, v in pairs(labels) do
--   labels[k] = string.format("%s ", v)
-- end
