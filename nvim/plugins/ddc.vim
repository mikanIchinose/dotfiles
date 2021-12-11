call ddc#custom#patch_global('sources', ['around', 'gitmoji', 'gh_issues'])

call ddc#custom#patch_global('keywordPattern', '[a-zA-Z_:]\w*')

call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
        \ 'matchers': ['matcher_head'],
        \ 'sorters': ['sorter_rank']
        \ },
      \ })
call ddc#custom#patch_global('sourceOptions', {
      \ 'around': {'mark': 'Ar'},
      \ })
call ddc#custom#patch_global('sourceOptions', {
      \ 'gitmoji': { 
        \ 'mark': 'gitmoji',
        \ 'matchers': ['gitmoji'],
        \ 'sorters': [],
        \ },
      \ })
call ddc#custom#patch_global('sourceOptions', {
      \ 'gh_issues': {'mark': 'issue'},
      \ })
call ddc#custom#patch_global('sourceParams', {
      \ 'gitmoji': {
        \ 'altCodes': {
          \ ':bug:': ':fix:',
          \ ':sparkles:': ':feat:',
          \ ':fire:': ':remove:',
          \ ':memo:': ':doc:',
          \ ':recycle:': ':refactor:',
          \ ':bookmark:': ':tag:',
          \ ':heavy_plus_sign:': ':add:',
          \ ':lipstick:': ':add:',
          \ ':bento:': ':asset:',
          \ ':hammer:': ':script:',
          \ ':wrench:': ':conf:',
          \ },
        \ },
      \ })
" experimental interface
" call ddc#custom#patch_global('sourceParams', {
"       \ 'gitmoji': {
"         \ 'type': {
"           \ ':build': [':heavy_plus_sign:'],
"           \ ':chore': [':heavy_plus_sign:'],
"           \ ':ci': [':heavy_plus_sign:'],
"           \ ':docs': [':heavy_plus_sign:'],
"           \ ':feat': [':heavy_plus_sign:'],
"           \ ':fix': [':heavy_plus_sign:'],
"           \ ':update': [':heavy_plus_sign:'],
"           \ ':style': [':heavy_plus_sign:'],
"           \ ':test': [':heavy_plus_sign:'],
"           \ ':refactor': [':heavy_plus_sign:'],
"           \ },
"         \ },
"       \ })

inoremap <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

call ddc#enable()
" call ddc#disable()
