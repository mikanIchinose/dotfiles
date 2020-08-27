let g:ale_sign_error = '❌'
let g:ale_sign_warning = ''
let g:ale_echo_msg_format = 'ALE [%linter%]%code: %%s'
highlight link ALEErrorSign Tag
highlight link ALEWarningSign StorageClass

" ファイル保存時に自動fixする
let g:ale_fix_on_save = 1

" LSPの機能はCoc.nvimを使用するためALE側は無効にする
let g:ale_disable_lsp = 1

let g:ale_linters = {
    \ 'javascript': ['eslint'],
    \ 'vue': ['eslint'],
    \ 'python': ['flake8', 'mypy'],
    \ 'php': ['php', 'phpcs'],
    \ 'rust': ['rls'],
    \ 'json': ['jsonlint'],
    \ }
let g:ale_fixers = {
    \ 'javascript': ['eslint', 'prettier-eslint'],
    \ 'vue': ['eslint'],
    \ 'python': ['autopep8', 'isort'],
    \ 'php': ['php_cs_fixer'],
    \ 'rust': ['rustfmt'],
    \ }
