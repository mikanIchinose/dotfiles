let g:ale_sign_error = '❌'
let g:ale_sign_warning = ''
let g:ale_echo_msg_format = '[%linter%]%code: %%s'
highlight link ALEErrorSign Tag
highlight link ALEWarningSign StorageClass

" ファイル保存時に自動fixする
let g:ale_fix_on_save = 1

let g:ale_linters = {
    \ 'python': ['flake8'],
    \ 'php': ['php', 'phpcs']
    \ }
let g:ale_fixers = {
    \ 'python': ['black', 'isort'],
    \ 'php': ['phpcbf']
    \ }
