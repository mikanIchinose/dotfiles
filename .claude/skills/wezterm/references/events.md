# WezTerm イベントハンドラ

## 基本構文

```lua
wezterm.on('event-name', function(...)
  -- 処理
end)
```

## format-tab-title

タブタイトルのカスタマイズ。同期イベント（高速に返す必要あり）。

```lua
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local title = pane.title
  return string.format(' %d: %s ', tab.tab_index + 1, title)
end)
```

戻り値: 文字列 or FormatItem テーブル（色・スタイル指定可）

```lua
return {
  { Background = { Color = 'blue' } },
  { Foreground = { Color = 'white' } },
  { Text = ' title ' },
}
```

### TabInformation のフィールド

- `tab_id`, `tab_index`, `is_active`, `is_last_active`
- `active_pane` — PaneInformation
- `tab_title`, `window_id`, `window_title`

### PaneInformation のフィールド

- `pane_id`, `title`, `is_active`, `is_zoomed`
- `foreground_process_name` — 実行中プロセスのパス
- `current_working_dir` — カレントディレクトリ（URL オブジェクト、`.file_path` でパス取得）
- `has_unseen_output` — 未読出力の有無
- `domain_name` — ドメイン名

## format-window-title

ウィンドウタイトルのカスタマイズ。

```lua
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  return 'my wezterm'
end)
```

## update-status（update-right-status の後継）

タブバーのステータスエリア更新。定期的に発火。

```lua
wezterm.on('update-status', function(window, pane)
  window:set_right_status(wezterm.format {
    { Text = wezterm.strftime '%H:%M' },
  })
end)
```

## bell

ベル通知。

```lua
wezterm.on('bell', function(window, pane)
  window:toast_notification('WezTerm', 'Bell!', nil, 4000)
end)
```

## 詳細ドキュメント

- 全イベント: `/tmp/wezterm/docs/config/lua/window-events/`
- Mux イベント: `/tmp/wezterm/docs/config/lua/mux-events/`
- GUI イベント: `/tmp/wezterm/docs/config/lua/gui-events/`
- wezterm.format: `/tmp/wezterm/docs/config/lua/wezterm/format.md`
