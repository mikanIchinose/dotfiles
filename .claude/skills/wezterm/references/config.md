# WezTerm 設定ファイル

## 設定ファイルの場所（優先順）

1. `--config-file` CLI 引数
2. `$WEZTERM_CONFIG_FILE` 環境変数
3. `$XDG_CONFIG_HOME/wezterm/wezterm.lua`
4. `$HOME/.config/wezterm/wezterm.lua`
5. `$HOME/.wezterm.lua`

設定はホットリロード対応。`CTRL+SHIFT+R` で手動リロード可能。

## config_builder（推奨）

```lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'iceberg-dark'
config.font_size = 15.0

return config
```

- 存在しない設定キーで警告が出る（タイポ防止）
- `config:set_strict_mode(true)` でエラーに昇格可能

## モジュール分割

`~/.config/wezterm/` 配下に Lua モジュールを配置可能。

```lua
-- ~/.config/wezterm/appearance.lua
local module = {}
function module.apply_to_config(config)
  config.color_scheme = 'iceberg-dark'
end
return module
```

```lua
-- wezterm.lua
local appearance = require 'appearance'
local config = wezterm.config_builder()
appearance.apply_to_config(config)
return config
```

## CLI からの設定オーバーライド

```bash
wezterm --config enable_scroll_bar=true
wezterm --config 'exit_behavior="Hold"'
```

## 詳細ドキュメント

- 設定ファイル全般: `/tmp/wezterm/docs/config/files.md`
- 全設定オプション（174項目）: `/tmp/wezterm/docs/config/lua/config/`
- config_builder: `/tmp/wezterm/docs/config/lua/wezterm/config_builder.md`
