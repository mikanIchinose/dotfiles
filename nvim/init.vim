" メッセージを減らす（a:略記 T:長文は中央を省略 I:起動画面なし c:補完メッセージなし F:ファイル情報なし oO:上書き表示 s:検索の折り返し通知なし S:検索件数なし W:書き込み通知なし）
set shortmess=aTIcFoOsSW
set showtabline=0 " タブラインを非表示
set laststatus=0 " ステータスラインを非表示
set noruler noshowcmd noshowmode " カーソル位置・入力中のコマンド・モード名を非表示
set signcolumn=yes " サイン列を常に表示して、診断の表示で横にずれるのを防ぐ
set cmdheight=0

lua << EOF
require('vim._core.ui2').enable({ msg = { targets = {
  default   = 'cmd',
  echomsg   = 'msg', -- vim.notify の INFO/WARN と :echomsg
  echoerr   = 'msg', -- vim.notify の ERROR と :echoerr
  emsg      = 'msg', -- 通常のエラー
  wmsg      = 'msg', -- 警告
  progress  = 'msg', -- LSP などの進捗（fidget の代わり）
  lua_print = 'msg', -- print() の出力
} } })
EOF
set messagesopt+=timeout:4000,pager:<CR> " 通知を4秒出す。: コマンドの直後に <CR> で一覧を開く


" ウィンドウタイトルに相対パス・cwd・ファイル種別と状態を出す
set title
let &g:titlestring = [
      \   "%{expand('%:p:~:.')}",
      \   "%<\(%{fnamemodify(getcwd(), ':~')}\)",
      \   "%(%y%m%r%)",
      \ ]->join()

set mouse= " マウス無効化
set clipboard+=unnamedplus " ヤンクをクリップボードに渡す

set expandtab " タブ文字の代わりにスペースを入れる
set tabstop=2 " ファイル内のタブ文字を2桁幅で表示する
set softtabstop=2 " <Tab>や<BS>で2桁ずつ動く
set shiftwidth=2 " >> や自動インデントの幅を2桁にする

" Luaモジュールの読み込みをバイトコードキャッシュで速くする（実験的な機能）
lua vim.loader.enable()

let g:mapleader = "\<Space>"
let g:maplocalleader = 'm'

" プラグイン管理（goda-pm.vim）。プラグインの一覧は goda.toml、設定は goda-pm/main.go
const s:goda_pm_base = '~/.cache/goda-pm'->expand()
let $BASE_DIR = '<script>:h'->expand()
function s:goda_rtp(repo) abort
  let dir = s:goda_pm_base .. '/repos/github.com/' .. a:repo
  if !dir->isdirectory()
    call system(['git', 'clone', 'https://github.com/' .. a:repo, dir])
  endif
  execute 'set runtimepath^=' .. dir->fnameescape()
endfunction
call s:goda_rtp('Shougo/goda-pm.vim')
if s:goda_pm_base->goda_pm#min#load_state()
  " 状態ファイルがないときは作る（作るのに goda.vim が要る）
  call s:goda_rtp('Shougo/goda.vim')
  autocmd VimEnter * ++once call goda_pm#make_state(s:goda_pm_base)
endif
filetype plugin indent on " goda-pm の状態ファイルが切るので、有効に戻す
syntax on

" コマンドライン補完
" 入力するたびに補完候補のポップアップを出す（: と / と ?）
autocmd CmdlineChanged [:\/\?] call wildtrigger()
set wildmode=noselect:lastused,full " 最初は何も選ばない。直前に使った候補を先頭に置く
set wildoptions=pum " 候補をポップアップメニューで出す

" 補完の表示中でも <Up>/<Down> で履歴をたどれるようにする
cnoremap <expr> <Up>   wildmenumode() ? "\<C-E>\<Up>"   : "\<Up>"
cnoremap <expr> <Down> wildmenumode() ? "\<C-E>\<Down>" : "\<Down>"

"" keymap
" move window
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
" nnoremap <C-l> <C-w>l <C-l>は規定値があるらしい

" split
nnoremap <Leader>- <Cmd>split<CR>
nnoremap <Leader>\ <Cmd>vsplit<CR>

nnoremap <Leader>n <Cmd>nohlsearch<CR>

" visual mode util
xnoremap r <C-v>
xnoremap v V

nnoremap ; :

" navigation at insert-mode
inoremap <M-h> <Left>
inoremap <M-j> <Down>
inoremap <M-k> <Up>
inoremap <M-l> <Right>
" navigation at command-mode
cnoremap <M-h> <Left>
cnoremap <M-j> <Down>
cnoremap <M-k> <Up>
cnoremap <M-l> <Right>
" navigation at terminal-mode
tnoremap jj <C-\><C-n>

" easy save
nnoremap <Leader><Leader> <Cmd>silent update<CR>

" easy escape
inoremap jj <ESC>
inoremap j<Space> j

