" :RustFmt
command! -bar -buffer RustFmt call rustfmt#Format()

" easy format on save
nnoremap <buffer> <Leader><Leader> <Cmd>silent RustFmt<CR><Cmd>silent update<CR><Cmd>set cmdheight=0<CR>
