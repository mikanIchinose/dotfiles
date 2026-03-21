local wezterm = require 'wezterm'
local tab_title = require 'tab_title'
local status_bar = require 'status_bar'
local config = wezterm.config_builder()

tab_title.setup()
status_bar.setup()

-- macskkと干渉しないようにする
-- https://zenn.dev/vim_jp/articles/wezterm-karabiner
-- config.use_ime = false
config.color_scheme = 'iceberg-dark'
config.font = wezterm.font('PlemolJP Console NF', { weight = 'Regular' })
-- config.font = wezterm.font('UDEV Gothic 35NFLG', { weight = 'Regular' })
config.font_size = 15.0
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_max_width = 32
-- config.window_background_opacity = 0.8
config.macos_window_background_blur = 30
-- config.window_background_image = '/Users/mikan/.config/wezterm/background.jpg'
-- config.background = {
--   {
--     source = {
--       File = '/Users/mikan/.config/wezterm/background.jpg',
--     },
--   },
-- }
-- config.macos_forward_to_ime_modifier_mask = 'SHIFT|CTRL'
config.keys = {
  { key = 'd', mods = 'CMD', action = wezterm.action.SplitPane { direction = 'Right' } },
  { key = 'd', mods = 'CMD|SHIFT', action = wezterm.action.SplitPane { direction = 'Down' } },
}

return config
