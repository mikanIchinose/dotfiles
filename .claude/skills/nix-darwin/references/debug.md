# デバッグする

`<name>` は flake の darwinConfiguration 名。症状から入る。

## 評価（eval）エラー

`darwin-rebuild build` / `nix eval` が落ちる。

```sh
# スタックトレースを出す（どのモジュール・どの行かを特定）
nix eval --show-trace .#darwinConfigurations.<name>.system
darwin-rebuild build --flake .#<name> --show-trace
```

よくある原因:
- **型エラー** … 渡した値が `type` に合わない → `references/docs.md` で型を再確認。
- **option does not exist** … (a) オプション名のタイポ、(b) 新規ファイルを `git add` していない（`references/verify.md` の落とし穴）、(c) ピン版に存在しない（`/tmp/nix-darwin/modules` を grep して確認）。
- **assertion failed** … モジュールの前提条件違反。例: `nix.gc.automatic` は `nix.enable = false` の環境では使えない。メッセージのモジュールを `/tmp/nix-darwin/modules` で読む。

## nix repl で対話的に潜る

config ツリーを手で辿るのが一番速いことが多い。

```sh
nix repl
nix-repl> :lf .
nix-repl> darwinConfigurations.<name>.config.system.defaults.dock
nix-repl> darwinConfigurations.<name>.options.system.defaults.dock.autohide.type
```

- `config.<path>` … マージ後の最終値
- `options.<path>` … その option の宣言（`.type` / `.default` / `.description`）

## 世代差分を見る（何が変わったのか）

ビルドは通るが挙動が変わった／壊れたとき、前の世代との差分を取る。

```sh
nix-diff /run/current-system ./result   # 現行 vs これからビルドした system
darwin-rebuild --list-generations
```

`nix-diff` が無ければ `nix store diff-closures /run/current-system ./result` でも依存差分が見える。

## 適用したのに反映されない

switch は成功したが OS に効いていない。

1. **本当に最終 config に入っているか** → `nix eval .#darwinConfigurations.<name>.config.<path>`（`references/verify.md`）。入っていなければ設定／マージの問題。
2. **入っているのに OS に出ていない** → 実装を読む（`references/implementation.md`）。defaults 系なら再ログイン／再起動が必要なケース、対象ドメインが想定と違うケースがある。`defaults read <domain>` で実値を確認。
3. **activation script が失敗していないか** → switch 時のログを見直す。

## ロールバック

壊したら直前の世代に戻す。

```sh
darwin-rebuild --rollback        # 直前の世代へ
# もしくは特定世代の activate を実行（--list-generations で番号を確認）
```

## 切り分けの順序

1. eval が通るか（`--show-trace`）
2. 値が config に入っているか（`nix eval config.<path>`）
3. OS に反映されているか（`defaults read` / `launchctl list`）
4. 直前から何が変わったか（`nix-diff`）
