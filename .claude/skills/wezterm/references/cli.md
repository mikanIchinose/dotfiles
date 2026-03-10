# WezTerm CLI

## 主要コマンド

| コマンド | 説明 |
|---------|------|
| `wezterm start` | 新しいウィンドウを起動 |
| `wezterm connect` | マルチプレクサドメインに接続 |
| `wezterm ssh` | SSH 接続 |
| `wezterm serial` | シリアルポート接続 |
| `wezterm imgcat` | ターミナルに画像を表示 |
| `wezterm ls-fonts` | 利用可能なフォント一覧 |
| `wezterm show-keys` | キーバインド一覧表示 |
| `wezterm show-keys --lua` | Lua 形式でキーバインド出力 |
| `wezterm record` | ターミナルセッションの記録 |
| `wezterm replay` | 記録の再生 |

## wezterm cli サブコマンド

実行中の WezTerm インスタンスを操作するコマンド群。

| コマンド | 説明 |
|---------|------|
| `wezterm cli list` | ペイン一覧 |
| `wezterm cli list-clients` | 接続クライアント一覧 |
| `wezterm cli spawn` | 新しいペイン/タブ/ウィンドウを生成 |
| `wezterm cli split-pane` | ペインを分割 |
| `wezterm cli send-text` | テキストを送信 |
| `wezterm cli get-text` | ペインのテキストを取得 |
| `wezterm cli activate-pane` | ペインをアクティブに |
| `wezterm cli activate-pane-direction` | 方向指定でペイン切り替え |
| `wezterm cli activate-tab` | タブをアクティブに |
| `wezterm cli set-tab-title` | タブタイトルを設定 |
| `wezterm cli set-window-title` | ウィンドウタイトルを設定 |
| `wezterm cli adjust-pane-size` | ペインサイズ調整 |
| `wezterm cli zoom-pane` | ペインズーム |
| `wezterm cli kill-pane` | ペインを閉じる |
| `wezterm cli move-pane-to-new-tab` | ペインを新タブへ移動 |
| `wezterm cli rename-workspace` | ワークスペース名変更 |

## 詳細ドキュメント

- CLI 全般: `/tmp/wezterm/docs/cli/`
- CLI サブコマンド: `/tmp/wezterm/docs/cli/cli/`
