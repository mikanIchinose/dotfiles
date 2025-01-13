local wezterm = require 'wezterm'
return {
  audible_bell = "Disabled",
  color_scheme = 'iceberg-dark',
  font = wezterm.font('PlemolJP Console NF', { weight = 'Regular' }),
  -- font = wezterm.font('UDEV Gothic 35NFLG', { weight = 'Regular' }),
  font_size = 15.0,
  enable_tab_bar = false,
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  },
  window_background_opacity = 0.9,
}
