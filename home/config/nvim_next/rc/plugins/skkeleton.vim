" hook_add {{{
inoremap <C-j> <Plug>(skkeleton-toggle)
cnoremap <C-j> <Plug>(skkeleton-toggle)
tnoremap <C-j> <Plug>(skkeleton-toggle)
" }}}

" hook_source {{{
call skkeleton#config(#{
      \ globalJisyo: '~/.config/SKK-JISYO.L',
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

" autocmd MikanAutoCmd User skkeleton-initialize-pre call s:skkeleton_init()
autocmd MikanAutoCmd User skkeleton-enable-pre call s:skkeleton_pre()
autocmd MikanAutoCmd User skkeleton-disable-pre call s:skkeleton_post()

function! s:skkeleton_init() abort
  call skkeleton#config(#{
        \ globalJisyo: '~/.config/SKK-JISYO.L',
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
function! s:skkeleton_pre() abort
  let b:includes = ['markdown']
  if index(b:includes, &filetype) >= 0
    call skkeleton#config(#{
      \ keepState: v:true,
      \ })
  else
    call skkeleton#config(#{
      \ keepState: v:false,
      \ })
  endif
endfunction
function! s:skkeleton_post() abort
endfunction

call skkeleton#initialize() " skkeletonのロードを速くする
lua require('skkeleton-indicator')
" }}}
