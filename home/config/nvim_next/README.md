# 新しいNeovimの設定

## 起動方法

まだ設定中のため起動時にはオプションを渡します

```sh
vim -u init.vim {file}
```

## Concept

### Single Responsibility

各種設定がスパゲティ構造にならないようにする

## Feature

- lsp
- autocomplete
- fuzzy-search
- tree-viewer
- keymap
- japanese input
- syntax highlight

## 日本語入力

skkeleton
kuuさんの設定をもとに skkeleton の状態を virtual text として表示するようにしている

## 補完

### ddc

engine: ddc.vim
ui: pum.vim + ddc-ui-pum
source:
  for everything
    ddc-source-around
    ddc-source-rg
    ddc-source-file
    ddc-source-path
    ddc-source-mocword
  for vimscript
    neco-vim
  for cmdline
    ddc-source-cmdline
    ddc-source-cmdline-history
  for source code
    ddc-source-nvim-lsp + ddc-nvim-lsp-setup
  for terminal
    ddc-source-shell-native
  supported for ddc
    skkeleton
  filter:
    ddc-fuzzy
    ddc-onp
    ddc-sorter_rank
    ddc-matcher_head
    ddc-matcher_length
    ddc-converter_remove_overlap
    ddc-converter_truncate_abbr

### github copilot

## あいまい検索

ddu + ddu-ui-ff

## ファイラー

ddu + ddu-ui-filer

## lsp

```lua
-- inlay-hint
-- https://vinnymeller.com/posts/neovim_nightly_inlay_hints/
-- buffer local
:lua vim.lsp.inlay_hint(0, true)
-- global hook
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint(args.buf, true)
        end
        -- whatever other lsp config you want
    end
})
```

