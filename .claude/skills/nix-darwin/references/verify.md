# 動作確認する

目的: 実機に switch する **前** に、ビルドが通り、値が意図通りかを確かめる。`<name>` は flake の darwinConfiguration 名（例: `darwinConfigurations.<name>`）。

## 1. switch せずビルドする（最も安全）

実機を変更せずに、評価＋ビルドが成功するかだけを確かめる。

```sh
darwin-rebuild build --flake .#<name>
```

- 成功すれば `./result` に system が生成される（activation は走らない）。
- eval エラー・型エラー・ビルド失敗はここで全て出る。詰まったら `references/debug.md`。

## 2. オプション値を eval して確かめる（ビルド不要・高速）

「書いた値が実際にその config に反映されているか」をピンポイントで確認する。

```sh
# 設定後の最終的な値を見る
nix eval .#darwinConfigurations.<name>.config.system.defaults.dock.autohide
# attrset 全体を見る
nix eval .#darwinConfigurations.<name>.config.homebrew.casks
```

`config.<option.path>` で **マージ後の最終値** が取れる。複数モジュールでマージされる設定の確認に有効。

## 3. flake 全体のチェック

```sh
nix flake check
```

## 4. 実際に適用する

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

switch 後、実際に OS に反映されたかを確かめる。

```sh
# defaults 系
defaults read <domain> <key>
# launchd 系
launchctl list | grep <label>
ls ~/Library/LaunchAgents /Library/LaunchDaemons
```

反映されていなければ `references/debug.md` へ。
