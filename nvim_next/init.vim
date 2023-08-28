" Nvimの場合必要ない
" if &compatible
"   set nocompatible
" endif

augroup MikanAutoCmd
  autocmd!
augroup END

" True Colorが利用可能 かつ TUIで利用中 のとき True Colorを有効化
if exists('+termguicolors') && !has('gui_running')
  set termguicolors
endif

" UIをミニマルにする設定
" 1. メッセージ省略に関する制御
" 2. タブラインを表示しない
" 3. ステータスラインは常に非表示
set shortmess=aTIcFoOsSW showtabline=0 laststatus=0 
set noruler noshowcmd noshowmode
try
  set cmdheight=0
  " マクロ記録中は見えるようにする
  autocmd MikanAutoCmd CmdlineEnter,RecordingEnter * set cmdheight=1
  autocmd MikanAutoCmd CmdlineLeave,RecordingLeave * set cmdheight=0
  autocmd MikanAutoCmd BufWrite * lua vim.notify("save")
catch
  set cmdheight=1
endtry

" Title
set title
let &g:titlestring = [
      \   "%{expand('%:p:~:.')}",
      \   "%<\(%{fnamemodify(getcwd(), ':~')}\)",
      \   "%(%y%m%r%)",
      \ ]->join()

" 最低限ついておいてほしい装備
set mouse= " マウスを無効化
set clipboard+=unnamedplus " クリップボード連携
" set foldmethod=marker
lua if vim.loader then vim.loader.enable() end

let g:mapleader = "\<Space>"
let g:maplocalleader = 'm'

" set timeout timeoutlen=100 ttimeoutlen=200 updatetime=200

" Minimal keymap
" move window
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" split
nnoremap <Leader>- <Cmd>split<CR>
nnoremap <Leader>\ <Cmd>vsplit<CR>

nnoremap <Leader>n <Cmd>nohlsearch<CR>

xnoremap r <C-v>
xnoremap v V

nnoremap ; :

" ヘルプを垂直分割で開く 
autocmd! FileType help wincmd L

" load config
if filereadable(expand('~/.secret_vimrc'))
  source ~/.secret_vimrc
endif
execute 'source' $"{fnamemodify(expand('<sfile>'), ':h')}/rc/dein.vim"
let s:debug_mode = v:true
if s:debug_mode
  execute 'source' $"{fnamemodify(expand('<sfile>'), ':h')}/debug.vim"
endif

set secure
