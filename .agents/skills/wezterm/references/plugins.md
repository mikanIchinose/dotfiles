# WezTerm プラグイン

## インストール

```lua
local wezterm = require 'wezterm'
local plugin = wezterm.plugin.require 'https://github.com/owner/repo'

local config = wezterm.config_builder()
plugin.apply_to_config(config)
return config
```

## 更新

Debug Overlay（`CTRL+SHIFT+L`）の Lua REPL で:

```lua
wezterm.plugin.update_all()
```

## 削除

`wezterm.plugin.list()` でディレクトリを確認し、該当ディレクトリを削除。

## プラグイン開発

1. リポジトリに `plugin/init.lua` を作成
2. `apply_to_config(config)` 関数をエクスポート
3. ローカル開発時は `file://` URL で参照

```lua
local plugin = wezterm.plugin.require 'file:///path/to/local/plugin'
```

## プラグイン一覧

[awesome-wezterm](https://github.com/michaelbrusegard/awesome-wezterm)

## 詳細ドキュメント

- プラグイン全般: `/tmp/wezterm/docs/config/plugins.md`
- Plugin API: `/tmp/wezterm/docs/config/lua/wezterm.plugin/`
