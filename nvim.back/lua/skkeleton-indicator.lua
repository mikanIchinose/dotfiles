-- https://github.com/kuuote/dotvim/blob/e19acd0fdc1ea1ab1f6167f4a0982a2bc10c1dc1/conf/plug/skkeleton.lua#L42-L126
local function get_text()
  local state = vim.g['skkeleton#state']
  if state == nil then
    return ''
  end
  local text = ''
  if state.phase == 'input:okurinasi' then
    if vim.fn['skkeleton#mode']() == 'abbrev' then
      text = '/'
    else
      text = '>'
    end
  end
  if state.phase == 'input:okuriari' then
    text = '*'
  end
  if state.phase == 'henkan' then
    text = '<'
  end
  if text == '' then
    return vim.fn['skkeleton#mode']()
  end
  return text
end

local ns = vim.api.nvim_create_namespace('skkeleton')
local id = 1234321

local function line()
  return vim.fn.line('.') - 1
end

local function col()
  return vim.fn.col('.') - 1
end

local set = function()
  vim.api.nvim_buf_set_extmark(0, ns, line(), col(), {
    id = id,
    virt_text = { { get_text(), 'PMenuSel' } },
    virt_text_pos = 'eol',
  })
end
local reset = function()
  vim.api.nvim_buf_del_extmark(0, ns, id)
end

local autocmd = {
  define = vim.api.nvim_create_autocmd,
  group = vim.api.nvim_create_augroup,
}

autocmd.define('User', {
  pattern = 'skkeleton-enable-post',
  callback = function()
    autocmd.group('skkeleton-show-mode', { clear = true })
    autocmd.define('User', {
      pattern = 'skkeleton-handled',
      group = 'skkeleton-show-mode',
      callback = set,
    })
  end,
})
autocmd.define('User', {
  pattern = 'skkeleton-disable-post',
  callback = function()
    autocmd.group('skkeleton-show-mode', { clear = true })
    reset()
  end,
})

