# 動作確認する

目的: 実機に switch する **前** に、ビルドが通り、値が意図通りかを確かめる。

この dotfiles では home-manager が nix-darwin モジュールとして統合されているため、確認は **darwinConfiguration 経由** で行う。`<name>` は設定名（`personal` または `s34580`）、`<user>` は対応ユーザー（`mikan` / `s34580`）。

## 1. switch せずビルドする（最も安全）

実機を変更せずに、評価＋ビルドが成功するかだけを確かめる。home-manager 設定はシステム全体のビルドに含まれる。

```sh
darwin-rebuild build --flake .#<name>
```

- 成功すれば `./result` に system が生成される（activation は走らない）。
- eval エラー・型エラー・ビルド失敗はここで全て出る。詰まったら `references/debug.md`。

## 2. オプション値を eval して確かめる（ビルド不要・高速）

「書いた値が実際にその home-manager config に反映されているか」をピンポイントで確認する。

```sh
# home-manager 配下の最終的な値を見る
nix eval .#darwinConfigurations.<name>.config.home-manager.users.<user>.programs.git.userEmail
# attrset 全体を見る
nix eval .#darwinConfigurations.<name>.config.home-manager.users.<user>.home.packages --apply 'map (p: p.name)'
nix eval .#darwinConfigurations.<name>.config.home-manager.users.<user>.home.sessionVariables
```

`config.home-manager.users.<user>.<option.path>` で **マージ後の最終値** が取れる。複数モジュールでマージされる設定の確認に有効。

## 3. flake 全体のチェック

```sh
nix flake check
```

## 4. 実際に適用する

home-manager 単体の switch ではなく、システムごと switch する。

```sh
sudo darwin-rebuild switch --flake .#<name>
```

プロジェクトに switch ラッパー（`git add` + switch + GC をまとめたスクリプト等）があればそれを使う。

## 落とし穴: flake は git 管理下のファイルしか見ない

**新規ファイルを追加したら `git add` するまで flake から見えない。** 新しいモジュールを作って import したのに「option does not exist」「file not found」になる典型原因。

```sh
git add -A   # 新規ファイルを stage（commit は不要、stage で十分）
```

build / switch の前にこれを確認する。switch ラッパーがこれを自動でやっている場合もある。

## 適用後の実機確認

switch 後、実際にユーザー環境に反映されたかを確かめる。

```sh
# 生成された設定ファイルを確認（home.file / xdg.configFile / programs.* の出力）
cat ~/.config/git/config
ls -la ~/.config
# home-manager の世代
home-manager generations 2>/dev/null || ls -l ~/.local/state/nix/profiles/home-manager* 2>/dev/null
# ユーザー launchd エージェント
ls ~/Library/LaunchAgents
launchctl list | grep <label>
```

反映されていなければ `references/debug.md` へ。
