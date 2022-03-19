local call = vim.call

-- @param string option_name
-- @param table|list|string value
local function patch_global(option_name, value)
  call('ddc#custom#patch_global', option_name, value)
end

local function patch_filetype(filetypes,option_name, value)
  call('ddc#custom#patch_filetype', filetypes, option_name, value)
end

local ddc_all = {
  sourceOptions = {
    matchers = {'matcher_fuzzy', 'matcher_length'},
    sorters = {'sorter_fuzzy'},
    converters = {'converter_fuzzy', 'converter_remove_overlap'},
  },
}

local nvim_lsp = {
  sourceOptions = {
    mark = 'Ⓛ ',
    forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
  },
  -- sourceParams = {
    -- kindLabels = {
      -- Class = 'c'
    -- },
  -- },
}

local around = {
  sourceOptions = {
    mark = 'Ⓐ ',
  },
}

local rg = {
  sourceOptions = {
    mark = 'Ⓡ ',
    minAutoCompleteLength = 4,
  },
}

local file = {
  sourceOptions = {
    mark = ' ',
    isVolatile = true,
    forceCompletionPattern = '\\S/\\S*',
  }
}

local buffer = {
  sourceOptions = {
    mark = '﬘ ',
  },
  sourceParams = {
    requireSameFiletype = false,
    limitBytes = 5000000,
    fromAltBuf = true,
    forceCollect = true,
  }
}

patch_global('sources', {'around', 'rg', 'file'})
patch_global('sourceOptions', {
  ['_'] = ddc_all.sourceOptions,
  ['nvim-lsp'] = nvim_lsp.sourceOptions,
  around = around.sourceOptions,
  rg = rg.sourceOptions,
  file = file.sourceOptions,
})
patch_global('sourceParams', {
  ['nvim-lsp'] = nvim_lsp.sourceParams,
})

patch_filetype({'typescript'}, 'sources', {'nvim-lsp', 'rg', 'file'})
patch_filetype({'lua', 'kotlin'}, 'sources', {'nvim-lsp', 'rg'})

-- use pum.vim
patch_global('autoCompleteEvents', {
  'InsertEnter', 'TextChangedI', 'TextChangedP',
  'CmdlineEnter', 'CmdlineChanged',
})
patch_global('completionMenu', 'pum.vim')

-- keymapping
-- vim.cmd [[
-- set completeopt=menuone,noinsert
-- 
-- inoremap <silent><expr> <TAB>
-- \ pumvisible() ? '<C-n>' :
-- \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
-- \ '<TAB>' : ddc#map#manual_complete()
-- 
-- inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'
-- inoremap <expr><Down> pumvisible() ? "<C-n>" : "<Down>"
-- inoremap <expr><Up> pumvisible() ? "<C-p>" : "<Up>"
-- inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"
-- ]]

vim.cmd [[
set completeopt=menuone,noinsert
inoremap <silent><expr> <TAB>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
      \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
      \ '<TAB>' : ddc#manual_complete()

inoremap <silent><expr> <S-Tab> pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : '<S-Tab>'
inoremap <C-j> <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <C-k> <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <C-y> <Cmd>call pum#map#confirm()<CR>
inoremap <C-e> <Cmd>call pum#map#cancel()<CR>
inoremap <silent><expr> <C-l> ddc#map#extend()
inoremap <silent><expr> <CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
inoremap <silent><expr> <Esc> pum#visible() ? '<Cmd>call pum#map#cancel()<CR><Esc>' : '<Esc>'
]]

call('ddc#enable')
