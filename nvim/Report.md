# NOTE: 起動速度の妨げになってる部分の調査

avarage への影響で見る
いまのところ平均 30ms までを許容範囲とする

不足プラグインチェックは影響なし

```vim
if dein#check_install()
  call dein#install()
endif
```

## lazy.toml

nvim-notify
影響なし

context_filetype.vim
影響なし

which-key.nvim
VimEnter 影響あり
CursorHold 影響なし

junkfile.vim
影響なし

heirline.nvim
ファイルを指定しない状態で起動すると cmdheight=0 とあいまってどうてもちらつく
そのためロードタイミングを BufRead とする

bufferline.nvim
影響なし

rest.nvim
影響なし

noice.nvim
影響なし

everforest
カラースキームはどうしてもロード時間を食ってしまう
遅延ロードにもっていったらむしろ起動時間が短くなったんだが(謎
やっぱこれだとうまく色が入らないね
base.toml で宣言しておいて colorscheme を呼ぶタイミングを BufRead とかにしておけば起動速度に影響がない

lsp 系
影響なし
