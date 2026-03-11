local wezterm = require 'wezterm'

local M = {}

local LEFT_HALF = utf8.char(0xe0b6)
local RIGHT_HALF = utf8.char(0xe0b4)
local PR_ICON = utf8.char(0xea64) .. ' ' .. utf8.char(0xf4af)
local SEPARATOR = utf8.char(0x2502)
local TAB_BG = 'none'

local review_prs = {}
local review_prs_last_fetched = 0

local function fetch_review_prs()
  local success, stdout = wezterm.run_child_process {
    '/bin/zsh', '-lc',
    'gh search prs --review-requested=mikanIchinose --state=open --json repository,number --jq \'[.[] | select(.repository.name == "oisixAndroid" or .repository.name == "oisixiOS") | .repository.name] | group_by(.) | map({ name: .[0], count: length })\'',
  }
  if success then
    review_prs_last_fetched = os.time()
    review_prs = {}
    local json = stdout:gsub('%s+$', '')
    if json ~= '' and json ~= '[]' then
      review_prs = wezterm.json_parse(json)
    end
  end
end

local function render_pills(cells)
  local elements = {}
  for i, cell in ipairs(cells) do
    if i > 1 then
      table.insert(elements, { Background = { Color = TAB_BG } })
      table.insert(elements, { Text = ' ' })
    end
    table.insert(elements, { Background = { Color = TAB_BG } })
    table.insert(elements, { Foreground = { Color = cell.bg } })
    table.insert(elements, { Text = LEFT_HALF })
    table.insert(elements, { Background = { Color = cell.bg } })
    table.insert(elements, { Foreground = { Color = cell.fg } })
    table.insert(elements, { Text = ' ' .. cell.text .. ' ' })
    table.insert(elements, { Background = { Color = TAB_BG } })
    table.insert(elements, { Foreground = { Color = cell.bg } })
    table.insert(elements, { Text = RIGHT_HALF })
  end
  return elements
end

function M.setup()
  wezterm.on('update-status', function(window)
    local now = os.time()
    if now - review_prs_last_fetched >= 300 then
      fetch_review_prs()
    end

    local cells = {}

    if #review_prs > 0 then
      local parts = {}
      for _, repo in ipairs(review_prs) do
        table.insert(parts, PR_ICON .. '  ' .. repo.name .. '|' .. tostring(repo.count))
      end
      local text = table.concat(parts, ' ' .. SEPARATOR .. ' ')
      table.insert(cells, { text = text, bg = '#ffaa00', fg = '#000000' })
    end
    table.insert(cells, { text = wezterm.strftime '%m/%d %a %H:%M', bg = '#44bbff', fg = '#000000' })

    window:set_right_status(wezterm.format(render_pills(cells)))
  end)
end

return M
