local call = vim.call

-- @param string option_name
-- @param table|list|string value
local function patch_global(option_name, value)
  call('ddc#custom#patch_global', option_name, value)
end

local ddc_all = {
  sourceOptions = {
    matchers = {'matcher_fuzzy'},
    --sorters = {'sorter_fuzzy'},
    converters = {'converter_fuzzy'},
  },
}

local nvim_lsp = {
  sourceOptions = {
    mark = 'lsp',
    forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
  },
  sourceParams = {
    kindLabels = {
      Class = 'c'
    },
  },
}

local around = {
  sourceOptions = {
    mark = 'A',
  },
}

local rg = {
  sourceOptions = {
    mark = 'rg',
    minAutoCompleteLength = 4,
  },
}

patch_global('sources', {'nvim-lsp', 'around', 'rg'})
--patch_global('completionMenu', 'pum.vim')
patch_global('sourceOptions', {
  ['_'] = ddc_all.sourceOptions,
  ['nvim-lsp'] = nvim_lsp.sourceOptions,
  around = around.sourceOptions,
  rg = rg.sourceOptions,
})
patch_global('sourceParams', {
  ['nvim-lsp'] = nvim_lsp.sourceParams,
  })

vim.cmd [[
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"
set completeopt=menuone,noinsert

inoremap <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

inoremap <expr><Down> pumvisible() ? "<C-n>" : "<Down>"
inoremap <expr><Up> pumvisible() ? "<C-p>" : "<Up>"
]]

call('ddc#enable')
--call('popup_preview#enable')
