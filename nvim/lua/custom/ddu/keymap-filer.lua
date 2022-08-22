local map = vim.keymap.set

---@param action string
---@param params table|nil
---@return function
local function do_action(action, params)
  if params ~= nil then
    return function()
      vim.call('ddu#ui#filer#do_action', action, params)
    end
  else
    return function()
      vim.call('ddu#ui#filer#do_action', action)
    end
  end
end

-- NOTE: not support multi items
local function deleteItem()
  vim.call('ddu#ui#filer#do_action', 'itemAction', { name = 'getSourceName' })
  local action
  if vim.b.ddu_source_name == 'buffer' then
    action = 'bdelete'
  elseif vim.b.ddu_source_name == 'file' then
    action = 'delete'
  else
    -- vim.b.ddu_source_name = ''
    vim.call('ddu#ui#filer#do_action', 'chooseAction')
    return
  end
  vim.call('ddu#ui#filer#do_action', 'itemAction', { name = action })
  -- vim.call('ddu#ui#filer#do_action', 'checkItems')
  -- vim.call('ddu#ui#filer#multi_actions', {
  --   { 'itemAction', { name = action } },
  --   { 'checkItems' },
  -- })
  -- vim.b.ddu_source_name = ''
end

local opts = { buffer = true, silent = true }

map('n', '<C-l>', do_action('checkItems'), opts)
map('n', 'a', do_action('chooseAction'), opts)
map('n', 'q', do_action('quit'), opts)
map('n', 'o', do_action('expandItem', { mode = 'toggle' }), opts)
map('n', 's', do_action('toggleSelectItem'), opts)
map('n', 'S', do_action('toggleAllItems'), opts)
map('n', 'd', deleteItem, opts)
map('n', '<CR>', do_action('itemAction'), opts)
map('n', 'n', do_action('itemAction', { name = 'newFile' }), opts)
map('n', 'D', do_action('itemAction', { name = 'newDirectory' }), opts)
map('n', 'x', do_action('itemAction', { name = 'executeSystem' }), opts)
map('n', 'r', do_action('itemAction', { name = 'rename' }), opts)
map('n', 'm', do_action('itemAction', { name = 'move' }), opts)
map('n', 'p', do_action('itemAction', { name = 'paste' }), opts)
map('n', 'c', function()
  vim.call('ddu#ui#filer#multi_actions', {
    { 'itemAction', { name = 'copy' } },
    { 'clearSelectAllItems' },
  })
end, opts)
