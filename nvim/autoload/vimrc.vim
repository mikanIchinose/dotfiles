let s:hidden_all = 0
function! vimrc#toggle_statusline() abort
  if s:hidden_all == 0
    let s:hidden_all = 1
    setlocal noshowmode
    setlocal noruler
    setlocal noshowcmd
    setlocal laststatus=0
    setlocal cmdheight=0
  else
    let s:hidden_all = 0
    setlocal showmode
    setlocal ruler
    setlocal showcmd
    setlocal laststatus=3
    setlocal cmdheight=1
  endif
endfunction
