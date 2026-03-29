local wezterm = require 'wezterm'

local M = {}

-- パスからファイル名だけ取り出す
-- /path/to/file -> file
local function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

local process_colors = {
  ['nvim'] = { bg = '#56B6C2', inactive_bg = '#2B5B61', fg = '#282C34' },
  ['.claude-wrapped'] = { bg = '#D4A373', inactive_bg = '#6A523A', fg = '#282C34' },
}

function M.setup()
  wezterm.on('format-tab-title', function(tab)
    local pane = tab.active_pane
    local index = tab.tab_index + 1
    local has_tab_title = tab.tab_title and #tab.tab_title > 0
    local title = has_tab_title and tab.tab_title or pane.title
    local cwd = pane.current_working_dir
    local dir = cwd and basename(cwd.file_path) or ''
    local process = basename(pane.foreground_process_name or '')

    -- Claude Code ステータスプレフィックス ([DONE], [WAIT])
    -- Claude 終了後にプレフィックスが残る場合はクリアする
    local claude_status = nil
    if has_tab_title then
      if process == '.claude-wrapped' then
        claude_status = tab.tab_title
      else
        local t = tab.tab_title
        if t == '🟢' or t == '💬' then
          has_tab_title = false
        end
      end
    end

    -- アクティブタブのプレフィックスをクリア
    if tab.is_active and claude_status then
      local mux_tab = wezterm.mux.get_tab(tab.tab_id)
      if mux_tab then
        mux_tab:set_title('')
      end
      claude_status = nil
    end

    local text
    if claude_status then
      text = string.format('%d: %s %s ', index, claude_status, dir)
    elseif has_tab_title then
      text = string.format('%d: %s ', index, title)
    else
      text = string.format('%d: %s ~ %s ', index, dir, title)
    end

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
end

return M
