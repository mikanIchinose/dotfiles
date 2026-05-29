# WezTerm ペイン操作

## ペイン分割

### SplitPane（推奨）

```lua
{ key = 'd', mods = 'CMD', action = wezterm.action.SplitPane { direction = 'Right' } },
{ key = 'd', mods = 'CMD|SHIFT', action = wezterm.action.SplitPane { direction = 'Down' } },
```

パラメータ:
- `direction` — `"Up"`, `"Down"`, `"Left"`, `"Right"`（必須）
- `size` — `{Cells=10}` or `{Percent=50}`（デフォルト: 50%）
- `command` — SpawnCommand（省略時は default_prog）
- `top_level` — `true` でタブ全体を分割

### SplitHorizontal / SplitVertical（旧 API）

```lua
wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
```

## ペイン間移動

```lua
{ key = 'LeftArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left' },
{ key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right' },
{ key = 'UpArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up' },
{ key = 'DownArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down' },
```

## ペインリサイズ

```lua
{ key = 'LeftArrow', mods = 'CTRL|SHIFT|ALT', action = wezterm.action.AdjustPaneSize { 'Left', 1 } },
```

## ペインズーム

```lua
{ key = 'z', mods = 'CTRL|SHIFT', action = wezterm.action.TogglePaneZoomState },
```

## ペイン閉じる

```lua
wezterm.action.CloseCurrentPane { confirm = true }
```

## PaneSelect（対話的ペイン選択）

```lua
wezterm.action.PaneSelect
wezterm.action.PaneSelect { mode = 'SwapWithActive' }  -- 入れ替え
```

## 詳細ドキュメント

- SplitPane: `/tmp/wezterm/docs/config/lua/keyassignment/SplitPane.md`
- Pane オブジェクト API: `/tmp/wezterm/docs/config/lua/pane/`
- 全キーアクション: `/tmp/wezterm/docs/config/lua/keyassignment/`
