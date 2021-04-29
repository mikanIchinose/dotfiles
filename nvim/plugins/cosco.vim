" <leader>;
autocmd FileType php,rust,java nmap <silent> <Leader>; <Plug>(cosco-commaOrSemiColon)
autocmd FileType php,rust,java imap <silent> <Leader>; <c-o><Plug>(cosco-commaOrSemiColon)
" let g:auto_comma_or_semicolon = 1
let g:cosco_filetype_whitelist = ['php', 'rust', 'java']
