" hook_add {{{
inoremap <C-j> <Plug>(skkeleton-toggle)
cnoremap <C-j> <Plug>(skkeleton-toggle)
tnoremap <C-j> <Plug>(skkeleton-toggle)
" }}}

" hook_source {{{
call skkeleton#config(#{
      \ globalDictionaries: [
      \   '~/.config/skk-dict/SKK-JISYO.L',
      \   '~/.config/skk-dict/SKK-JISYO.law',
      \   '~/.config/skk-dict/zipcode/SKK-JISYO.zipcode',
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

" autocmd MikanAutoCmd User skkeleton-initialize-pre call s:skkeleton_init()
function! s:skkeleton_init() abort
  call skkeleton#config(#{
        \ globalDictionaries: [
        \   '~/.config/skk-dict/SKK-JISYO.L',
        \   '~/.config/skk-dict/SKK-JISYO.law',
        \   '~/.config/skk-dict/zipcode/SKK-JISYO.zipcode',
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

autocmd MikanAutoCmd User skkeleton-enable-pre call s:skkeleton_pre()
function! s:skkeleton_pre() abort
  " override ddc sources
  let s:prev_buffer_config = ddc#custom#get_buffer()
    call ddc#custom#patch_buffer(#{
            \   sources: ['around', 'skkeleton'],
            \   sourceOptions: #{
            \     _: #{
            \       keywordPattern: '[ァ-ヮア-ンー]+',
            \     },
            \   },
            \ })

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

" autocmd MikanAutoCmd User skkeleton-disable-post call s:skkeleton_post()
function! s:skkeleton_post() abort
  if exists('s:prev_buffer_config')
    " Restore sources
    call ddc#custom#set_buffer(s:prev_buffer_config)
  endif
endfunction

" autocmd MikanAutoCmd User skkeleton-mode-changed call s:skkeleton_changed()
function! s:skkeleton_changed() abort
  const mode = g:skkeleton#mode
  let state = ''
  if exists('g:skkeleton#state')
    let state = g:skkeleton#state.phase
  endif

  if state ==# 'henkan'
    highlight CursorLine       gui=NONE guibg=#f04060 guifg=fg
  else
    if mode ==# 'hira'
      highlight CursorLine       gui=NONE guibg=#80403f guifg=fg
    " elseif mode ==# 'kata'
    "   highlight CursorLine       gui=NONE guibg=#f04060 guifg=fg
    elseif mode ==# 'abbrev'
      highlight CursorLine       gui=NONE guibg=#60f060 guifg=fg
    else
      highlight CursorLine       gui=NONE guibg=#606060 guifg=fg
    endif
  endif
endfunction

lua require('skkeleton-indicator')
call skkeleton#initialize() " skkeletonのロードを速くする
" }}}
