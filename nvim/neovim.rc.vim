set inccommand=nosplit
" set pumblend=20
" set winblend=20

" NOTE: event notifier
" autocmd BufRead * lua vim.notify('BufRead ' .. vim.fn.expand('%'))
" autocmd BufReadPre * lua vim.notify('BufReadPre ' .. vim.fn.expand('%'))
" autocmd BufReadPost * lua vim.notify('BufReadPost ' .. vim.fn.expand('%'))
" autocmd BufEnter * lua vim.notify('BufEnter ' .. vim.fn.expand('%'))
" autocmd VimEnter * lua vim.notify('VimEnter')
" autocmd WinEnter * lua vim.notify('WinEnter ' .. vim.fn.winnr())

" NOTE: Brewfile treat as ruby-file
augroup brewfile
  autocmd BufRead Brewfile set filetype=ruby
augroup END

command! ToggleStatusLine call vimrc#toggle_statusline()

" ddc-gitmoji
" let g:denops#debug = 1
" set runtimepath^=~/ghq/github.com/mikanIchinose/ddc-gitmoji
" set runtimepath^=~/LocalProject/ddc-deno-import-map

lua << EOF
vim.notify = require("notify")
require("keymapping")
require("custom.which-key")
EOF

augroup ftplugin
  autocmd FileType null-ls-info nnoremap q <CMD>quit<CR>
augroup END

function! InsertTodo() abort
  let comment = ''
  if exists('b:caw_oneline_comment')
    let comment =  printf('%s %s:  ', b:caw_oneline_comment, 'TODO')
    exe 'normal! a' . comment . '\<Esc>'
  else
    " let comment =  printf("%s %s:  %s", b:caw_wrap_oneline_comment[0], "TODO", b:caw_wrap_oneline_comment[1])
    " exe "normal! a" . comment . "\<Esc>"
    " exe "normal! T:"
    " exe "normal! l"
    let comment =  printf('%s\n%s: \n%s', b:caw_wrap_oneline_comment[0], 'TODO', b:caw_wrap_oneline_comment[1])
    exe 'normal! a' . comment . "\<Esc>"
    exe 'normal! k'
    exe 'normal! $'
  endif
  :startinsert
endfunction
command! InsertTodo call InsertTodo()

if exists('g:neovide')
  let g:neovide_transparency = 0.8
  let g:neovide_remember_window_size = v:true
  if has('mac')
    let g:neovide_input_macos_alt_is_meta = v:true
  endif
endif
