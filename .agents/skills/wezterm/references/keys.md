# WezTerm キーバインド設定

## 基本構文

```lua
config.keys = {
  { key = 'd', mods = 'CMD', action = wezterm.action.SplitPane { direction = 'Right' } },
}
```

## 修飾キー

| ラベル | キー |
|--------|------|
| `SUPER`, `CMD`, `WIN` | macOS: Command / Win: Windows / Linux: Super |
| `CTRL` | Control |
| `SHIFT` | Shift |
| `ALT`, `OPT`, `META` | macOS: Option / 他: Alt |
| `LEADER` | モーダル修飾キー |

複数修飾キーは `|` で結合: `"CMD|SHIFT"`, `"CTRL|SHIFT|ALT"`

## Physical vs Mapped キー

- `phys:A` — ANSI US キーボードの物理位置で指定
- `mapped:a` — OS キーボードレイアウトで変換後の値で指定
- プレフィックスなし — `key_map_preference` 設定に従う（デフォルト: `Mapped`）

## Leader Key

```lua
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = '|', mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
}
```

## デフォルトキー（主要なもの）

| Mods | Key | Action |
|------|-----|--------|
| `CMD` | `c` | CopyTo Clipboard |
| `CMD` | `v` | PasteFrom Clipboard |
| `CMD` | `t` | SpawnTab |
| `CMD` | `w` | CloseCurrentTab |
| `CMD` | `n` | SpawnWindow |
| `CMD` | `1`-`9` | ActivateTab |
| `CMD` | `f` | Search |
| `CTRL+SHIFT+ALT` | `"` | SplitVertical |
| `CTRL+SHIFT+ALT` | `%` | SplitHorizontal |
| `CTRL+SHIFT` | 矢印 | ActivatePaneDirection |
| `CTRL+SHIFT` | `Z` | TogglePaneZoomState |

全一覧: `/tmp/wezterm/docs/config/default-keys.md`

## デフォルトキーの無効化

```lua
-- 個別無効化
{ key = 'm', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment },

-- 全て無効化
config.disable_default_key_bindings = true
```

## デバッグ

```lua
config.debug_key_events = true
```

## 詳細ドキュメント

- キー設定全般: `/tmp/wezterm/docs/config/keys.md`
- 全アクション一覧: `/tmp/wezterm/docs/config/lua/keyassignment/`
- Key Tables: `/tmp/wezterm/docs/config/key-tables.md`
