let g:which_key_map =  {}
call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

let g:which_key_sep = '->'

autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
let g:which_key_map.w = {
    \ 'name' : '+windows' ,
    \ 'w' : ['<C-W>w'     , 'other-window']          ,
    \ 'd' : ['<C-W>c'     , 'delete-window']         ,
    \ '-' : ['<C-W>s'     , 'split-window-below']    ,
    \ '|' : ['<C-W>v'     , 'split-window-right']    ,
    \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
    \ 'h' : ['<C-W>h'     , 'window-left']           ,
    \ 'j' : ['<C-W>j'     , 'window-below']          ,
    \ 'l' : ['<C-W>l'     , 'window-right']          ,
    \ 'k' : ['<C-W>k'     , 'window-up']             ,
    \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
    \ 'J' : [':resize +5'  , 'expand-window-below']   ,
    \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
    \ 'K' : [':resize -5'  , 'expand-window-up']      ,
    \ '=' : ['<C-W>='     , 'balance-window']        ,
    \ 's' : ['<C-W>s'     , 'split-window-below']    ,
    \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
    \ '?' : ['Windows'    , 'fzf-window']            ,
    \ }
let g:which_key_map.f = {
      \ 'name' : '+fzf' ,
      \ 'f' : [':Files<CR>'   , 'Files'   ],
      \ 'b' : [':Buffers<CR>' , 'Buffer'  ],
      \ 'g' : [':Rg<CR>'      , 'Rg'      ],
      \ 't' : [':Tags<CR>'    , 'Tags'    ],
      \ 'm' : [':Marks<CR>'   , 'Marks'   ],
      \ }
let g:which_key_map['/'] = [ '<Plug>NERDCommenterToggle'  , 'comment' ]
