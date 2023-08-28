function vimrc#sticky_func() abort
  const sticky_table = {
        \  ',': '<', '.': '>', '/': '?',
        \  '1': '!', '2': '@', '3': '#', '4': '$', '5': '%',
        \  '6': '^', '7': '&', '8': '*', '9': '(', '0': ')',
        \  '-': '_', '=': '+',
        \  ';': ':', '[': '{', ']': '}', '`': '~', "'": "\"", '\': '|',
        \ }
  const special_table = {
        \  "\<ESC>": "\<ESC>", "\<Space>": ';', "\<CR>": ";\<CR>",
        \ }

  let char = ''

  while 1
    silent! let char = getchar()->nr2char()

    if char =~# '\l'
      let char = char->toupper()
      break
    elseif sticky_table->has_key(char)
      let char = sticky_table[char]
      break
    elseif special_table->has_key(char)
      let char = special_table[char]
      break
    endif
  endwhile

  return char
endfunction
