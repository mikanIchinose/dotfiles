let s:hidden_all = 0
function! vimrc#toggle_statusline() abort
  " FIX: ちらつく
  " if s:hidden_all == 0
  "   let s:hidden_all = 1
  "   setlocal noshowmode
  "   setlocal noruler
  "   setlocal noshowcmd
  "   setlocal laststatus=0
  "   setlocal cmdheight=0
  " else
  "   let s:hidden_all = 0
  "   setlocal showmode
  "   setlocal ruler
  "   setlocal showcmd
  "   setlocal laststatus=3
  "   setlocal cmdheight=1
  " endif
endfunction

function! vimrc#on_filetype() abort
  if execute('filetype') !~# 'OFF'
  " if !exists('b:did_ftplugin')
  "   runtime! after/ftplugin.vim
  " endif

    return
  endif

  filetype plugin indent on
  syntax enable

  " NOTE: filetype detect does not work on startup
  filetype detect
endfunction
