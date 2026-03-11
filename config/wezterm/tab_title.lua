local wezterm = require 'wezterm'

local M = {}

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
end

return M
