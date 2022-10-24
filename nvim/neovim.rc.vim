" NOTE: event notifier
" autocmd BufRead * lua vim.notify('BufRead ' .. vim.fn.expand('%'))
" autocmd BufReadPre * lua vim.notify('BufReadPre ' .. vim.fn.expand('%'))
" autocmd BufReadPost * lua vim.notify('BufReadPost ' .. vim.fn.expand('%'))
" autocmd BufEnter * lua vim.notify('BufEnter ' .. vim.fn.expand('%'))
" autocmd VimEnter * lua vim.notify('VimEnter')
" autocmd WinEnter * lua vim.notify('WinEnter ' .. vim.fn.winnr())
" autocmd LspAttach * lua vim.notify('LspAttach')
" autocmd LspDetach * lua vim.notify('LspDetach')
" autocmd BufRead * lua vim.notify('BufRead')
" autocmd BufReadPost * lua vim.notify('BufReadPost')

" NOTE: Brewfile treat as ruby-file
augroup brewfile
  autocmd BufRead Brewfile set filetype=ruby
augroup END

" augroup TransparentBG
"   autocmd!
"   autocmd ColorScheme * call TransparentBG()
" augroup END
function! TransparentBG() abort
  highlight Normal      guibg=NONE ctermbg=NONE
  highlight NonText     guibg=none ctermbg=none
  highlight LineNr      guibg=none ctermbg=none
  highlight SignColumn  guibg=none ctermbg=none
  highlight Folded      guibg=none ctermbg=none
  highlight EndOfBuffer guibg=none ctermbg=none
endfunction
" call TransparentBG()
highlight Comment gui=italic guifg=#B79175

command! ToggleStatusLine call vimrc#toggle_statusline()

function! DeinClean()
  if len(dein#check_clean()) > 0
    lua vim.notify('remove these plugins\n' .. table.concat(vim.call('dein#check_clean'),'\n'))
    call map(dein#check_clean(), "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
  else
    lua vim.notify('No disabled plugins', vim.log.levels.ERROR)
  endif
endfunction
command! DeinClean call DeinClean()

" local plugin
" set runtimepath^=~/ghq/github.com/mikanIchinose/ddc-gitmoji
" set runtimepath^=~/ghq/github.com/mikanIchinose/ddu-source-zenn_article
set runtimepath^=~/ghq/github.com/mikanIchinose/ddu-source-zenn
set runtimepath^=~/ghq/github.com/mikanIchinose/ddu-source-nvim-lsp
set runtimepath^=~/ghq/github.com/mikanIchinose/ddu-source-markdown


function! InsertTodo() abort
  let comment = ''
  if exists('b:caw_oneline_comment')
    let comment =  printf('%s %s:  ', b:caw_oneline_comment, 'TODO')
    exe 'normal! a' . comment . '\<Esc>'
  else
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

lua << EOF
require("keymapping")
require("custom.which-key")
EOF
