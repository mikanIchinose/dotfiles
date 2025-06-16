" ロード高速化
lua if vim.loader then vim.loader.enable() end

augroup MyAutoCmd
  autocmd!
augroup END

set showtabline=0 " タブバー非表示
set laststatus=0 " ステータスライン非表示
set noshowmode " モード非表示
set noshowcmd " コマンド非表示
set noruler " ルーラー非表示

"- a - "search hit BOTTOM, continuing at TOP" 等の検索メッセージの短縮
"- T - ファイルが途中で切り詰められた場合のメッセージを短縮
"- I - 起動時のイントロメッセージを非表示
"- c - 補完メッセージを短縮
"- F - ファイル読み込み/書き込みメッセージの一部を短縮
"- o - "読み取り専用"などのメッセージの短縮
"- O - ファイルメッセージの短縮
"- s - "検索がヒットしました"メッセージを短縮
"- S - 検索カウントメッセージを短縮
"- W - "written" メッセージの省略
set shortmess=aTIcFoOsSW

set cmdheight=0
" マクロ記録中は見えるようにする
autocmd MyAutoCmd CmdlineEnter,RecordingEnter * set cmdheight=1
autocmd MyAutoCmd CmdlineLeave,RecordingLeave * set cmdheight=0

set title

" expand('%:p:~:.') => 今開いているファイルのパスを、見やすい形で表示する
" fnamemodify(getcwd(), ':~') => 現在の作業ディレクトリ（カレントディレクトリ）のパスを、ホームディレクトリ部分は ~ で短縮して表示する
" %<\(...\) => 長すぎる場合は切り詰める
" %y => ファイルタイプ
" %m => 変更フラグ
" %r => 読み取り専用フラグ
let &g:titlestring = [
      \   "%{expand('%:p:~:.')}",
      \   "%<\(%{fnamemodify(getcwd(), ':~')}\)",
      \   "%(%y%m%r%)",
      \ ]->join()

set mouse= " マウスを無効化
set clipboard+=unnamedplus " クリップボード連携

set smartindent " C-likeなインデントを自動で付ける
set smarttab expandtab tabstop=2 softtabstop=2 shiftwidth=2

let g:mapleader = "\<Space>"
let g:maplocalleader = ','

execute 'source ' .. '<sfile>'->expand()->fnamemodify(':h') .. '/rc/dpp.vim'

