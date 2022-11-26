local root_pattern = require('lspconfig.util').root_pattern

local M = {}
-- M.denols = function(opts)
--   opts.root_dir = deno_root_dir
--   opts.init_options = {
--     enable = true,
--     lint = true,
--     unstable = true,
--   }
--   opts.single_file_support = false
-- end
-- M.tsserver = function(opts)
--   opts.root_dir = node_root_dir
--   opts.init_options = {
--     enable = true,
--     lint = true,
--     unstable = true,
--   }
--   opts.single_file_support = false
-- end
M.denols = {
  opts = {
    root_dir = root_pattern('deno.json', 'deno.jsonc', 'deps.ts', 'import_map.json'),
    init_options = {
      enable = true,
      lint = true,
      unstable = true,
    },
    -- single_file_support = false,
  },
}
M.tsserver = {
  opts = {
    root_dir = root_pattern('package.json'),
    -- init_options = {
    --   enable = true,
    --   lint = true,
    --   unstable = true,
    -- },
    -- single_file_support = false,
  },
}

return M
