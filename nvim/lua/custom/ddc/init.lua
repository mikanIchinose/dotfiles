local call = vim.call
local codicon = require('codicons')

local function patch_global(option_name, value)
  call('ddc#custom#patch_global', option_name, value)
end

local function patch_filetype(filetypes, option_name, value)
  call('ddc#custom#patch_filetype', filetypes, option_name, value)
end

local geticon = function(identifier)
  return codicon.get(identifier, 'icon')
end

local labels = {
  Text = "",
  Method = geticon('symbol-method'),
  Function = "",
  Constructor = "",
  Field = "ﰠ",
  Variable = geticon('symbol-variable'),
  Class = geticon('symbol-class'),
  Interface = "",
  Module = "",
  Property = geticon('symbol-property'),
  Unit = "塞",
  Value = "",
  Enum = geticon('symbol-enum'),
  Keyword = geticon('symbol-keyword'),
  Snippet = geticon('symbol-snippet'),
  Color = geticon('symbol-color'),
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = geticon('symbol-enum-member'),
  Constant = geticon('symbol-constant'),
  Struct = geticon('symbol-structure'),
  Event = geticon('symbol-event'),
  Operator = geticon('symbol-operator'),
  TypeParameter = "",
}

for k, v in pairs(labels) do
  labels[k] = string.format("%s ", v)
end

-- patch_global('sources', { 'nvim-lsp', 'around', 'rg', 'file' })
patch_global('sources', { 'skkeleton' })

patch_global('sourceOptions', {
  ['_'] = {
    matchers = { 'matcher_fuzzy', 'matcher_length' },
    sorters = { 'sorter_fuzzy' },
    converters = { 'converter_fuzzy', 'converter_remove_overlap' },
  },
  ['nvim-lsp'] = {
    mark = 'LSP',
    forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
  },
  necovim = {
    mark = 'vim'
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
    forceCompletionPattern = '\\S/\\S*',
  },
  skkeleton = {
    mark = 'skk',
    matchers = { 'skkeleton' },
    sorters = {},
    minAutoCompleteLength = 2,
  },
})
patch_global('sourceParams', {
  ['nvim-lsp'] = {
    kindLabels = labels,
  },
})

-- use pum.vim
patch_global('autoCompleteEvents', {
  'InsertEnter', 'TextChangedI', 'TextChangedP',
  'CmdlineEnter', 'CmdlineChanged',
})
patch_global('completionMenu', 'pum.vim')

patch_global('sources', { 'nvim-lsp', 'around', 'rg', 'file' })

patch_filetype(
  { 'javascript', 'typescript', 'dart', 'rust', 'zsh', 'lua' },
  'sources',
  { 'nvim-lsp', 'around', 'rg', 'file' }
)
patch_filetype(
  { 'yaml', 'json', 'jsonc' },
  'sources',
  { 'nvim-lsp', 'around' }
)
patch_filetype(
  { 'toml' },
  'sources',
  { 'nvim-lsp' }
)
patch_filetype(
  { 'vim' },
  'sources',
  { 'necovim', 'nvim-lsp' }
)

vim.cmd [[
inoremap <silent><expr> <TAB>
      \ ddc#map#pum_visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
      \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
      \ '<TAB>' : ddc#manual_complete()
inoremap <silent><expr> <S-Tab> ddc#map#pum_visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : '<S-Tab>'
inoremap <C-j> <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <C-k> <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <C-y> <Cmd>call pum#map#confirm()<CR>
inoremap <C-e> <Cmd>call pum#map#cancel()<CR>

" inoremap <silent><expr> <Tab> 
"   \ pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' : 
"   \ vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
" inoremap <silent><expr> <S-Tab> 
"   \ pum#visible() ? '<Cmd>call pum#map#select_relative(-1)<CR>' : 
"   \ vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
" inoremap <silent><expr> <C-l> ddc#map#extend()
" inoremap <silent> <C-Space> ddc#manual_complete('nvim-lsp')

"inoremap <silent><expr> <CR>   ddc#map#pum_visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
"inoremap <silent><expr> <Esc>  ddc#map#pum_visible() ? '<Cmd>call pum#map#cancel()<CR><Esc>' : '<Esc>'
" inoremap <silent><expr> <Down> pum#visible() ? "<Cmd>call pum#map#select_relative(+1)<CR>" : "<Down>"
" inoremap <silent><expr> <Up>   pum#visible() ? "<Cmd>call pum#map#select_relative(-1)<CR>" : "<Up>"

smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'

" snippetの展開を行う
autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)
]]
vim.keymap.set(
  "i",
  [[<C-Space>]],
  [[ddc#map#manual_complete()]],
  { expr = true }
)

call('ddc#enable')
