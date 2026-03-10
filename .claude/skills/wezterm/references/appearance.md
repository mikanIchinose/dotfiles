# WezTerm 外観設定

## カラースキーム

```lua
config.color_scheme = 'iceberg-dark'
```

700以上のビルトインスキームあり。`colors` で個別カラーをオーバーライド可能。

```lua
config.colors = {
  foreground = 'silver',
  background = 'black',
  cursor_bg = '#52ad70',
  selection_fg = 'black',
  selection_bg = '#fffacd',
}
```

## フォント

```lua
config.font = wezterm.font('PlemolJP Console NF', { weight = 'Regular' })
config.font_size = 15.0
```

## タブバー

| 設定 | デフォルト | 説明 |
|------|-----------|------|
| `enable_tab_bar` | `true` | タブバー表示 |
| `use_fancy_tab_bar` | `true` | ネイティブ風 / レトロ風 |
| `tab_bar_at_bottom` | `false` | 下部配置 |
| `hide_tab_bar_if_only_one_tab` | `false` | タブ1つ時に隠す |
| `show_tab_index_in_tab_bar` | `true` | タブ番号表示 |
| `show_new_tab_button_in_tab_bar` | `true` | +ボタン表示 |
| `show_close_tab_button_in_tabs` | `true` | 閉じるボタン表示 |
| `tab_max_width` | `16` | タブ最大幅（レトロのみ） |

### Fancy タブバーのスタイリング

```lua
config.window_frame = {
  font = wezterm.font { family = 'Roboto', weight = 'Bold' },
  font_size = 12.0,
  active_titlebar_bg = '#333333',
  inactive_titlebar_bg = '#333333',
}
```

### Retro タブバーのスタイリング

```lua
config.colors = {
  tab_bar = {
    background = '#0b0022',
    active_tab = { bg_color = '#2b2042', fg_color = '#c0c0c0' },
    inactive_tab = { bg_color = '#1b1032', fg_color = '#808080' },
    new_tab = { bg_color = '#1b1032', fg_color = '#808080' },
  },
}
```

## ウィンドウ

```lua
config.window_background_opacity = 0.8
config.macos_window_background_blur = 30
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_decorations = "RESIZE"
config.initial_cols = 120
config.initial_rows = 28
```

## 非アクティブペインの見た目

```lua
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}
```

## 詳細ドキュメント

- 外観全般: `/tmp/wezterm/docs/config/appearance.md`
- カラースキーム一覧: `/tmp/wezterm/docs/colorschemes/`
- フォント: `/tmp/wezterm/docs/config/fonts.md`
