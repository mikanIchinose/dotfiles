" 小文字を大文字に変換
" a〜z の小文字を押すと、自動的に大文字（A〜Z）に変換されます。
" 
" 記号の変換
" sticky_table に登録されている記号（例: , → <, 2 → @ など）は、Shiftを押したときの記号に変換されます。
" 
" 特殊キーの変換
" special_table に登録されている特殊キー（例: スペース→;、Enter→;+改行）は、指定された文字に変換されます。
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
