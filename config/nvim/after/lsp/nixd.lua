local host = vim.env.DOTFILES_HOST or "personal"
local flake = vim.env.HOME .. "/dotfiles"

---@type vim.lsp.Config
return {
  settings = {
    nixd = {
      nixpkgs = {
        expr = string.format('import (builtins.getFlake "%s").inputs.nixpkgs { }', flake),
      },
      formatting = { command = { "nixfmt" } },
      options = {
        ["nix-darwin"] = {
          expr = string.format('(builtins.getFlake "%s").darwinConfigurations.%s.options', flake, host),
        },
      },
    },
  },
}
