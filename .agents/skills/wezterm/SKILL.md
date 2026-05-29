---
name: wezterm
description: |
  WezTermの設定を調査・編集する。
  「wezterm」「ターミナル設定」「タブバー」「キーバインド」「フォント設定」と依頼された際に使用。
---

## セットアップ

まず `scripts/init.sh` を実行し、WezTermのソースコードが `/tmp/wezterm` にクローンされていることを確認する。

## 設定ファイル

`config/wezterm/wezterm.lua` — `~/.config/wezterm/wezterm.lua` に symlink される。

## リファレンス

機能を調べるときは、まず該当する references を読み、必要に応じて `/tmp/wezterm/docs/` のソースドキュメントを直接参照する。

| リファレンス | 内容 |
|-------------|------|
| `references/config.md` | 設定ファイルの書き方、config_builder、モジュール分割 |
| `references/keys.md` | キーバインド設定、修飾キー、Leader Key、デフォルトキー一覧 |
| `references/appearance.md` | 外観設定（カラースキーム、フォント、タブバー、背景、透過） |
| `references/events.md` | イベントハンドラ（タブタイトル、ウィンドウタイトル、ステータスバー） |
| `references/pane.md` | ペイン操作（分割、移動、リサイズ、ズーム） |
| `references/cli.md` | wezterm CLI サブコマンド |
| `references/plugins.md` | プラグインのインストール・管理・開発 |

## ソースドキュメントの場所

| パス | 内容 |
|------|------|
| `/tmp/wezterm/docs/config/lua/config/` | 全設定オプション（174項目） |
| `/tmp/wezterm/docs/config/lua/keyassignment/` | 全キーアサインメントアクション |
| `/tmp/wezterm/docs/config/lua/window-events/` | ウィンドウイベント |
| `/tmp/wezterm/docs/config/lua/pane/` | Pane オブジェクト API |
| `/tmp/wezterm/docs/config/lua/window/` | Window オブジェクト API |
| `/tmp/wezterm/docs/config/lua/wezterm/` | wezterm モジュール API |
| `/tmp/wezterm/docs/config/lua/wezterm.plugin/` | プラグイン API |
| `/tmp/wezterm/docs/cli/` | CLI ドキュメント |
