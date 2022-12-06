" auto fold
call cursor(1, 1)
let fold_pattern = 'Changes not staged for commit:\|Untracked files:'
let fold_from = search(fold_pattern, 'n')
if fold_from
  execute fold_from .. ',/--- >8 ---/fold'
endif

" conventional commit
function! s:select_type() abort
  let line = substitute(getline('.'), '^#\s*', '', 'g')
  let title = printf('%s: ', split(line, ' ')[0])

  silent! normal! "_dip
  silent! put! =title
  silent! startinsert!
endfunction

nnoremap <buffer> <C-y> <Cmd>call <SID>select_type()<CR>
