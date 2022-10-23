---@param option_name string
local function patch_global(option_name, value)
  vim.call('ddc#custom#patch_global', option_name, value)
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
    -- matchers = { 'matcher_head', 'matcher_length' },
    -- sorters = { 'sorter_rank' },
    -- converters = { 'converter_remove_overlap' },
    --matchers = { 'matcher_head' },
    -- fuzzy maching
    matchers = { 'matcher_fuzzy' },
    sorters = { 'sorter_rank' },
    converters = { 'converter_fuzzy', 'converter_remove_overlap' },
  },
  ['nvim-lsp'] = {
    mark = 'LSP',
    forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
    matchers = { 'matcher_fuzzy' },
    sorters = { 'sorter_rank' },
    converters = { 'converter_fuzzy', 'converter_remove_overlap' },
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
  cmdline = {
    mark = 'cmdline',
    forceCompletionPatter = [[\S/\S*]],
    dup = true,
  },
  ['cmdline-history'] = {
    mark = 'history',
    -- sorters = {},
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
  'CmdlineEnter',
  'CmdlineChanged',
})
patch_global('completionMenu', 'pum.vim')

-- set sources
patch_global('sources', { 'nvim-lsp', 'vsnip', 'around', 'rg', 'file' })
patch_global('cmdlinesSources', { 'cmdline-history', 'file', 'around' })
patch_filetype_with_option({ 'toml' }, 'sources', { 'nvim-lsp', 'necovim', 'around' })
patch_filetype_with_option({ 'vim' }, 'sources', { 'vsnip', 'necovim', 'nvim-lsp', 'around' })
patch_filetype_with_option(
  { 'norg' },
  'sources',
  { 'nvim-lsp', 'nvim-lsp_by-treesitter', 'treesitter', 'around', 'rg', 'file' }
)
patch_filetype({ 'FineCmdlinePrompt' }, {
  keywordPattern = '[0-9a-zA-Z_:#-]',
  sources = { 'cmdline-history', 'around' },
  specialBufferCompletion = true,
})

-- NOTE: ghost-textで補完するときに必要
-- patch_filetype({ 'markdown' }, 'specialBufferCompletion', 'v:true')
-- patch_global(
--   'specialBufferCompletion',
--   'v:true'
-- )

-- keymap
-- require('custom.ddc.keymap')
-- vim.cmd([[
-- inoremap <silent><expr> <TAB>
--  \ ddc#map#pum_visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
--  \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
--  \ '<TAB>' : ddc#manual_complete()
-- inoremap <silent><expr> <S-Tab>
--  \ ddc#map#pum_visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' :
--  \ '<S-Tab>'
-- " inoremap <C-j> <Cmd>call pum#map#select_relative(+1)<CR>
-- " inoremap <C-k> <Cmd>call pum#map#select_relative(-1)<CR>
-- inoremap <C-y> <Cmd>call pum#map#confirm()<CR>
-- inoremap <C-e> <Cmd>call pum#map#cancel()<CR>
-- inoremap <silent><expr> <C-Space> ddc#map#manual_complete()
--
-- " inoremap <silent><expr> <Tab>
-- "   \ pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' :
-- "   \ vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
-- " inoremap <silent><expr> <S-Tab>
-- "   \ pum#visible() ? '<Cmd>call pum#map#select_relative(-1)<CR>' :
-- "   \ vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
-- " inoremap <silent><expr> <C-l> ddc#map#extend()
-- " inoremap <silent> <C-Space> ddc#manual_complete('nvim-lsp')
--
-- " inoremap <silent><expr> <CR> ddc#map#pum_visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
-- " inoremap <silent><expr> <Esc> ddc#map#pum_visible() ? '<Cmd>call pum#map#cancel()<CR><Esc>' : '<Esc>'
-- " inoremap <silent><expr> <Down> pum#visible() ? "<Cmd>call pum#map#select_relative(+1)<CR>" : "<Down>"
-- " inoremap <silent><expr> <Up>   pum#visible() ? "<Cmd>call pum#map#select_relative(-1)<CR>" : "<Up>"
--
-- " smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
-- " smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
--
-- " snippetの展開を行う
-- " autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)
-- ]])

vim.call('ddc#enable')

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
