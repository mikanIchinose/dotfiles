local M = {}
M.opts = {
  settings = {
    evenBetterToml = {
      schema = {
        catalogs = {
          --'https://taplo.tamasfe.dev/schema_index.json',
          -- 古いスキーマが使われている
          'https://www.schemastore.org/api/json/catalog.json',
        },
        enable = true,
        -- associations = {},
      },
      formatter = {
        alignEntries = true,
      },
    },
  },
}
return M
