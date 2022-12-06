vim.g.lightline = {
  colorscheme = vim.g.colorscheme,
  active = {
    left = {
      { 'mode', 'paste', 'ddu' },
      { 'lsp_clients', 'hydra', 'skkeleton' },
      { 'modified', 'navic' },
    },
    right = {
      { 'lineinfo' },
      { 'gin' },
      {
        'readonly',
        -- 'relativepath',
        --   'fileformat',
        --   'filetype',
      },
    },
  },
  separator = { left = '', right = '' },
  subseparator = { left = '', right = '' },
  mode_map = {
    n = 'Normal',
    i = 'Insert',
    v = 'Visual',
    V = 'VLine',
    ['\\<C-v>'] = 'VBlock',
    c = 'Command',
    s = 'Select',
    S = 'SLine',
    ['\\<C-s>'] = 'SBlock',
    t = 'Terminal',
  },
  component_function = {
    skkeleton = 'g:LightlineSkkeleton',
    hydra = 'g:LightlineHydra',
    lsp_status = 'g:LightlineLspStatus',
    lsp_clients = 'g:LightlineLspClients',
    ddu = 'g:LightlineDdu',
    gin = 'g:LightlineGin',
    navic = 'g:LightlineNvimNavic',
  },
}

-- skkeletonの状態を表示
_G.lightline_skkeleton = function()
  if vim.api.nvim_eval([[get(g:, 'loaded_skkeleton')]]) == 0 then
    return ''
  end

  local lightline_mode = vim.call('lightline#mode')
  if lightline_mode == 'Insert' or lightline_mode == 'Command' then
    local skkeleton_mode = vim.call('skkeleton#mode')
    if skkeleton_mode == 'hira' then
      return 'あ'
    elseif skkeleton_mode == 'kata' then
      return 'ア'
    elseif skkeleton_mode == 'hankata' then
      return 'ｱ'
    elseif skkeleton_mode == 'zenkaku' then
      return 'Ａ'
    elseif skkeleton_mode == 'abbrev' then
      return 'abbrev'
    else
      return 'A'
    end
  end
  return ''
end
vim.cmd([[
function! g:LightlineSkkeleton() abort
  return v:lua.lightline_skkeleton()
endfunction
]])

-- hydraを起動したときにサブモードを表示
_G.lightline_hydra = function()
  local has_hydra, hydra = pcall(require, 'hydra.statusline')
  if not has_hydra then
    return ''
  end
  if hydra.is_active then
    if hydra.get_name() ~= nil then
      return hydra.get_name() .. '-mode'
    end
    return ''
  end
end
vim.cmd([[
function! g:LightlineHydra() abort
  return v:lua.lightline_hydra()
endfunction
]])

_G.lightline_lsp_status = function()
  local has_lsp_status, lsp_status = pcall(require, 'lsp-status')
  if not has_lsp_status then
    return ''
  end
  if #vim.lsp.buf_get_clients() > 0 then
    return lsp_status.status()
  end
end
vim.cmd([[
function! g:LightlineLspStatus() abort
  return v:lua.lightline_lsp_status()
endfunction
]])

-- 現在アクティブなLS名を列挙
_G.lightline_lsp_clients = function()
  if #vim.lsp.buf_get_clients() > 0 then
    local active_clients = {}
    for _, value in pairs(vim.lsp.buf_get_clients()) do
      table.insert(active_clients, value.name)
    end
    return string.format('%s %s', require('codicons').get('server', 'icon'), table.concat(active_clients, ' '))
  end
  return ''
end
vim.cmd([[
function! g:LightlineLspClients() abort
  return v:lua.lightline_lsp_clients()
endfunction
]])

_G.lightline_ddu = function()
  if vim.w.ddu_ui_ff_status then
    local status = vim.w.ddu_ui_ff_status
    return string.format('ddu:%s', status.name)
  end
  return ''
end
vim.cmd([[
function! g:LightlineDdu() abort
  return v:lua.lightline_ddu()
endfunction
]])

_G.lightline_gin = function()
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
end
vim.cmd([[
function! g:LightlineGin() abort
  return v:lua.lightline_gin()
endfunction
]])

_G.lightline_nvim_navic = function()
  local ok, navic = pcall(require, 'nvim-navic')
  if not ok then
    return ''
  end
  return navic.get_location()
end
vim.cmd([[
function! g:LightlineNvimNavic() abort
  return v:lua.lightline_nvim_navic()
endfunction
]])
