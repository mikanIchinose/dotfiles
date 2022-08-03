function! vimrc#toggle_statusline() abort
  if &laststatus == 3
    setlocal laststatus=0
  else
    setlocal laststatus=3
  endif

  if &cmdheight==1
    setlocal cmdheight=0
  else
    setlocal cmdheight=1
  endif
endfunction

