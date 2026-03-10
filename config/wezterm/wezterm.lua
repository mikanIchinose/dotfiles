local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

local process_colors = {
  ['nvim'] = { bg = '#56B6C2', inactive_bg = '#2B5B61', fg = '#282C34' },
  ['.claude-wrapped'] = { bg = '#D4A373', inactive_bg = '#6A523A', fg = '#282C34' },
}


wezterm.on('format-tab-title', function(tab)
  local pane = tab.active_pane
  local index = tab.tab_index + 1
  local title = pane.title
  local cwd = pane.current_working_dir
  local dir = cwd and basename(cwd.file_path) or ''
  local process = basename(pane.foreground_process_name or '')
  local text = string.format(' %d: %s ~ %s ', index, dir, title)

  local colors = process_colors[process]
  if colors then
    return {
      { Background = { Color = tab.is_active and colors.bg or colors.inactive_bg } },
      { Foreground = { Color = colors.fg } },
      { Text = text },
    }
  end

  return text
end)

-- macskkと干渉しないようにする
-- https://zenn.dev/vim_jp/articles/wezterm-karabiner
-- config.use_ime = false
config.color_scheme = 'iceberg-dark'
config.font = wezterm.font('PlemolJP Console NF', { weight = 'Regular' })
-- config.font = wezterm.font('UDEV Gothic 35NFLG', { weight = 'Regular' })
config.font_size = 15.0
config.enable_tab_bar = true
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
