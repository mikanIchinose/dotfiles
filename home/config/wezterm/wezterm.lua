local wezterm = require 'wezterm'

wezterm.on('bell', function(window, pane)
  window:toast_notification('Claude Code', 'Task completed', nil, 4000)
end)

return {
  -- macskkと干渉しないようにする
  -- https://zenn.dev/vim_jp/articles/wezterm-karabiner
  -- use_ime = false,
  color_scheme = 'iceberg-dark',
  font = wezterm.font('PlemolJP Console NF', { weight = 'Regular' }),
  -- font = wezterm.font('UDEV Gothic 35NFLG', { weight = 'Regular' }),
  font_size = 15.0,
  enable_tab_bar = false,
  -- window_background_opacity = 0.8,
  macos_window_background_blur = 30,
  -- window_background_image = "/Users/mikan/.config/wezterm/background.jpg",
  -- background = {
  --   {
  --     source = {
  --       File = "/Users/mikan/.config/wezterm/background.jpg",
  --     },
  --   },
  -- },
  -- macos_forward_to_ime_modifier_mask = "SHIFT|CTRL",
  audible_bell = "SystemBeep",
  keys = {
    -- { key = "Enter", mods = "ALT", action = wezterm.action.SendString("\\n") },
    {
      key = "Enter",
      mods = "ALT",
      action = wezterm.action.Multiple {
        -- 1. `\` を入力する
        wezterm.action.SendString '\\',
        -- 2. Enterキー を入力する
        wezterm.action.SendKey { key = 'Enter' },
      },
    },
  },
}
