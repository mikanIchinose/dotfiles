local nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
end

-- todo item
nmap('<Leader>td', '<Cmd>Neorg keybind norg core.norg.qol.todo_items.todo.task_done<CR>', 'task done')
nmap('<Leader>tu', '<Cmd>Neorg keybind norg core.norg.qol.todo_items.todo.task_undone<CR>', 'task undone')
nmap('<Leader>th', '<Cmd>Neorg keybind norg core.norg.qol.todo_items.todo.task_onhold<CR>', 'task onhold')
nmap('<Leader>tc', '<Cmd>Neorg keybind norg core.norg.qol.todo_items.todo.task_cancelled<CR>', 'task cancel')
nmap('<Leader>tp', '<Cmd>Neorg keybind norg core.norg.qol.todo_items.todo.task_pending<CR>', 'task pending')
nmap('<Leader>tr', '<Cmd>Neorg keybind norg core.norg.qol.todo_items.todo.task_recurring<CR>', 'task recurring')
nmap('<Leader>ti', '<Cmd>Neorg keybind norg core.norg.qol.todo_items.todo.task_important<CR>', 'task important')
nmap('<Leader><Leader>', '<Cmd>Neorg keybind norg core.norg.qol.todo_items.todo.task_cycle<CR>', 'task cycle')
-- gtd
-- nmap('<C-c>', '<Cmd>Neorg keybind norg core.gtd.base.capture<CR>', 'capture')
-- nmap('<Leader>gc', '<Cmd>Neorg keybind norg core.gtd.base.capture<CR>', 'capture')
-- nmap('<Leader>gv', '<Cmd>Neorg keybind norg core.gtd.base.views<CR>', 'view')
-- nmap('<Leader>ge', '<Cmd>Neorg keybind norg core.gtd.base.edit<CR>', 'edit')
--dirman
nmap('<Leader>nn', '<Cmd>Neorg keybind norg core.norg.dirman.new.note<CR>', 'new note')
-- header
nmap('<C-S-l>', '<Cmd>Neorg keybind norg core.promo.promote<CR>', 'header promote')
nmap('<C-S-h>', '<Cmd>Neorg keybind norg core.promo.demote<CR>', 'header demote')
nmap('<C-S-j>', '<Cmd>Neorg keybind norg core.integrations.treesitter.next.heading<CR>', 'next heading')
nmap('<C-S-k>', '<Cmd>Neorg keybind norg core.integrations.treesitter.previous.heading<CR>', 'previous heading')
-- hop
nmap('<M-CR>', '<Cmd>Neorg keybind norg core.norg.esupports.hop.hop-link<CR>', 'hop-link')
