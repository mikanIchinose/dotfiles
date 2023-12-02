local wezterm = require('wezterm')

local bg_image_path = ''
local weekdayNum = tonumber(wezterm.strftime("%u"))
if weekdayNum > 5 then
  -- weekend
  bg_image_path = wezterm.home_dir .. '/Pictures/wallpaper/overload_holy_kingdom.jpg'
else
  -- weekday
  bg_image_path = wezterm.home_dir .. '/Pictures/wallpaper/vim.jpeg'
end

return {
  audible_bell = "Disabled",
  color_scheme = 'iceberg-dark',
  font = wezterm.font('PleckJP', { weight = 'Regular' }),
  --font = wezterm.font('JetBrains Mono', { weight = 'Regular' }),
  font_size = 25.0,
  enable_tab_bar = false,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  window_background_image = bg_image_path,
  window_background_image_hsb = {
    brightness = 0.03,
  },
}
