M = {}

local lspconfig = require("lspconfig")

---@param root_dir function
local function detected_root_dir(root_dir)
  return not not (root_dir(vim.api.nvim_buf_get_name(0), vim.api.nvim_get_current_buf()))
end

local deno_root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts")
local node_root_dir = lspconfig.util.root_pattern("package.json", "node_modules")
local is_deno_proj = detected_root_dir(deno_root_dir)
local is_node_proj = detected_root_dir(deno_root_dir) and not is_deno_proj

M.denols = function(opts)
  opts.autostart = is_deno_proj
  --if is_deno_proj then
  opts.root_dir = deno_root_dir
  opts.init_options = {
    enable = true,
    lint = true,
    unstable = true,
  }
  opts.single_file_support = false
  --end
end

M.tsserver = function(opts)
  opts.autostart = is_node_proj
  -- if is_node_proj then
  opts.root_dir = node_root_dir
  opts.init_options = {
    enable = true,
    lint = true,
    unstable = true,
  }
  opts.single_file_support = false
  -- end
  -- end
end

return M
