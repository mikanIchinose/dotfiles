local M = {}

local root_pattern = require('lspconfig').util.root_pattern

---@param root_dir function
-- local function detected_root_dir(root_dir)
--   return not not (root_dir(vim.api.nvim_buf_get_name(0), vim.api.nvim_get_current_buf()))
-- end

local deno_root_dir = root_pattern('deno.json', 'deno.jsonc', 'deps.ts')
local node_root_dir = root_pattern('package.json', 'node_modules')
-- local is_deno_proj = detected_root_dir(deno_root_dir)
-- local is_node_proj = detected_root_dir(node_root_dir) and not is_deno_proj

M.denols = function(opts)
  opts.autostart = vim.b.tsdetect_is_node ~= 0
  opts.root_dir = deno_root_dir
  opts.init_options = {
    enable = true,
    lint = true,
    unstable = true,
  }
  opts.single_file_support = false
end

M.tsserver = function(opts)
  opts.autostart = vim.b.tsdetect_is_node == 0
  opts.root_dir = node_root_dir
  opts.init_options = {
    enable = true,
    lint = true,
    unstable = true,
  }
  opts.single_file_support = false
end

return M
