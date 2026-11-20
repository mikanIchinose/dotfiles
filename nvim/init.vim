" メッセージを減らす（a:略記 T:長文は中央を省略 I:起動画面なし c:補完メッセージなし F:ファイル情報なし oO:上書き表示 s:検索の折り返し通知なし S:検索件数なし W:書き込み通知なし）
set shortmess=aTIcFoOsSW
set showtabline=0 " タブラインを非表示
set laststatus=0 " ステータスラインを非表示
set noruler noshowcmd noshowmode " カーソル位置・入力中のコマンド・モード名を非表示
set signcolumn=yes " サイン列を常に表示して、診断の表示で横にずれるのを防ぐ
set cmdheight=0
set winborder=rounded " フローティングウィンドウ（LSP のホバーなど）に角丸の枠を付ける

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
  " 状態ファイルがないときは作る（作るのに goda.vim と、状態ファイルが呼ぶ goda-pm-ext-lazy.vim が要る）
  call s:goda_rtp('Shougo/goda.vim')
  call s:goda_rtp('Shougo/goda-pm-ext-lazy.vim')
  autocmd VimEnter * ++once call goda_pm#make_state(s:goda_pm_base)
endif
" goda.toml に足したプラグインを入れる。状態ファイル作成 → 読み直し → インストール → 状態ファイル作成（hook を入れるため）
function s:goda_install() abort
  call goda_pm#make_state_sync(s:goda_pm_base)
  call goda_pm#min#load_state(s:goda_pm_base) " installer はメモリ上の一覧を見るので読み直す
  filetype plugin indent on
  autocmd User GodaPm:extActionPost:installer:install ++once call goda_pm#make_state(s:goda_pm_base)
  call goda_pm#async_ext_action('installer', 'install')
endfunction
command! GodaInstall call s:goda_install()
filetype plugin indent on " goda-pm の状態ファイルが切るので、有効に戻す
syntax on

" treesitter で色を付ける。パーサとハイライトのルールは Nix で入れる（nix/hosts/common/home.nix の treesitterLangs）
autocmd FileType go,gomod,gosum,gowork lua vim.treesitter.start()

" コマンドライン補完
" 入力するたびに補完候補のポップアップを出す（: と / と ?）
autocmd CmdlineChanged [:\/\?] call wildtrigger()
set wildmode=noselect:lastused,full " 最初は何も選ばない。直前に使った候補を先頭に置く
set wildoptions=pum " 候補をポップアップメニューで出す

lua << EOF
-- 補完の表示中でも <Up>/<Down> で履歴をたどれるようにする
vim.keymap.set("c", "<Up>", function() return vim.fn.wildmenumode() == 1 and "<C-E><Up>" or "<Up>" end, { expr = true })
vim.keymap.set("c", "<Down>", function() return vim.fn.wildmenumode() == 1 and "<C-E><Down>" or "<Down>" end, { expr = true })
EOF

lua << EOF
local map = vim.keymap.set

-- ウィンドウ移動（<C-l> は画面の再描画なので上書きしない）
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-h>", "<C-w>h")

-- 分割
map("n", "<Leader>-", "<Cmd>split<CR>", { desc = "split horizontal" })
map("n", "<Leader>\\", "<Cmd>vsplit<CR>", { desc = "split vertical" })

map("n", "<Leader>n", "<Cmd>nohlsearch<CR>", { desc = "検索のハイライトを消す" })

-- ビジュアルモード
map("x", "r", "<C-v>", { desc = "矩形選択に切り替え" })
map("x", "v", "V", { desc = "行選択に切り替え" })

map("n", ";", ":", { desc = "コマンドラインを開く" })

-- 挿入モードとコマンドラインでのカーソル移動
map({ "i", "c" }, "<M-h>", "<Left>")
map({ "i", "c" }, "<M-j>", "<Down>")
map({ "i", "c" }, "<M-k>", "<Up>")
map({ "i", "c" }, "<M-l>", "<Right>")

map("t", "jj", "<C-\\><C-n>")

map("n", "<Leader><Leader>", "<Cmd>silent update<CR>", { desc = "保存" })

map("i", "jj", "<Esc>")
map("i", "j<Space>", "j")
EOF

" micro-which-key.nvim
set rtp^=~/ghq/github.com/mikanIchinose/micro-which-key.nvim
lua require('micro-which-key').setup()
