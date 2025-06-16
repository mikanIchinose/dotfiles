" hook_add {{{
inoremap <C-j> <Plug>(skkeleton-toggle)
"cnoremap <C-j> <Plug>(skkeleton-toggle)
"tnoremap <C-j> <Plug>(skkeleton-toggle)
" }}}

" hook_source {{{
call skkeleton#config(#{
      \ globalDictionaries: [
      \   '~/ghq/github.com/skk-dev/dict/SKK-JISYO.L',
      \   '~/ghq/github.com/skk-dev/dict/zipcode/SKK-JISYO.zipcode',
      \ ],
      \ eggLikeNewline: v:true,
      \ registerConvertResult: v:true,
      \ markerHenkan: '',
      \ markerHenkanSelect: '',
      \ })
call skkeleton#register_kanatable('rom', {
      \ 'jj': 'escape',
      \ '~': ['〜', ''],
      \ ':': [':'],
      \ 'z;': [';'],
      \ 'z/': ['/'],
      \ '\': ['\'],
      \ 'z-': ['-'],
      \ 'z,': [','],
      \ 'z.': ['.'],
      \ 'zh': ['←'],
      \ 'zj': ['↓'],
      \ 'zk': ['↑'],
      \ 'zl': ['→'],
      \ "z\<Space>": ["\u3000"],
      \ })

autocmd MikanAutoCmd User skkeleton-initialize-pre call s:skkeleton_init()
function! s:skkeleton_init() abort
  call skkeleton#config(#{
        \ globalDictionaries: [
      \   '~/ghq/github.com/skk-dev/dict/SKK-JISYO.L',
      \   '~/ghq/github.com/skk-dev/dict/zipcode/SKK-JISYO.zipcode',
        \ ],
        \ eggLikeNewline: v:true,
        \ registerConvertResult: v:true,
        \ markerHenkan: '',
        \ markerHenkanSelect: '',
        \ })
  call skkeleton#register_kanatable('rom', {
        \ 'jj': 'escape',
        \ '~' : ['〜', ''],
        \ ':' : [':'],
        \ 'z;': [';'],
        \ 'z/': ['/'],
        \ '\' : ['\'],
        \ 'z-': ['-'],
        \ 'z,': [','],
        \ 'z.': ['.'],
        \ 'zh': ['←'],
        \ 'zj': ['↓'],
        \ 'zk': ['↑'],
        \ 'zl': ['→'],
        \ "z\<Space>": ["\u3000"],
        \ })
endfunction

lua require('skkeleton-indicator')
call skkeleton#initialize() " skkeletonのロードを速くする
" }}}
