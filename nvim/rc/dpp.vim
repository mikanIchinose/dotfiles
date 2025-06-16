" Install(plugin)
" 引数で指定されたGitHubリポジトリ(例: 'Shougo/dpp.vim')を
" `$CACHE/dpp/repos/github.com/` 配下に `git clone` する関数。
"
" Args:
"   plugin (string): クローンする GitHub リポジトリ名 (例: 'org/repo')。
"
" Details:
"   - 指定された `plugin` 名からローカルのクローン先ディレクトリパスを構築する。
"   - ディレクトリがまだ存在しない場合のみ `git clone` を実行する。
"   - 存在する、またはクローンしたディレクトリの絶対パスを Vim の `'runtimepath'` の
"     先頭に追加する。これにより、プラグインが Vim から認識されるようになる。
function Install(plugin)
  let dir = $CACHE .. '/dpp/repos/github.com' .. a:plugin
  if !(dir->isdirectory())
    execute '!git clone https://github.com/' .. a:plugin dir
  endif

  execute 'set runtimepath^='
        \ .. dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endfunction

function DppMakeState()
  call dpp#make_state(s:dpp_base, '$BASE_DIR/dpp.ts'->expand())
endfunction

let $CACHE = '~/.cache'->expand()
const s:dpp_base = '~/.cache/dpp'->expand()
" = ~/.config/nvim/rc
const $BASE_DIR = '<sfile>'->expand()->fnamemodify(':h')

if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif

" install dpp.vim and dpp-ext-lazy
call Install('Shougo/dpp.vim')
call Install('Shougo/dpp-ext-lazy')

" load dpp's state and execute starup script
if dpp#min#load_state(s:dpp_base)
  " if state is old/invalid/not found
  for s:plugin in [
        \ 'Shougo/dpp-ext-installer',
        \ 'Shougo/dpp-ext-local',
        \ 'Shougo/dpp-ext-toml',
        \ 'Shougo/dpp-protocol-git',
        \ 'vim-denops/denops.vim',
        \ ]
    call Install(s:plugin)
  endfor

  runtime! plugin/denops.vim

  autocmd MyAutoCmd User DenopsReady
        \ echohl WarningMsg
        \ | echomsg 'dpp#load_state() is failed'
        \ | echohl NONE
        \ | call DppMakeState()
else
  autocmd MyAutoCmd User BufWritePost *.lua,*.vim,*toml,*ts
        \ call dpp#check_files()
endif

autocmd MyAutoCmd User Dpp:makeStatePost
      \ echohl WarningMsg
      \ | echomsg 'dpp#make_state() is done'

" filetype: ファイルタイプの検出
" plugin:   ファイルタイプにもとづいたプラグインの読み込み
" indent:   ファイルタイプにもとづいたインデント設定の読み込み
filetype plugin indent on

