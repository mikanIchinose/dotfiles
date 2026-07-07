# デバッグする

`<name>` は設定名（`personal` / `s34580`）、`<user>` は対応ユーザー（`mikan` / `s34580`）。症状から入る。

## 評価（eval）エラー

`darwin-rebuild build` / `nix eval` が落ちる。

```sh
# スタックトレースを出す（どのモジュール・どの行かを特定）
nix eval --show-trace .#darwinConfigurations.<name>.config.home-manager.users.<user>.home.packages
darwin-rebuild build --flake .#<name> --show-trace
```

よくある原因:
- **型エラー** … 渡した値が `type` に合わない → `references/docs.md` で型を再確認。
- **option does not exist** … (a) オプション名のタイポ、(b) 新規ファイルを `git add` していない（`references/verify.md` の落とし穴）、(c) ピン版に存在しない（`/tmp/home-manager/modules` を grep して確認）。
- **assertion failed** … モジュールの前提条件違反。例: `home.stateVersion` 未設定、相反する `programs.*` の同時有効化など。メッセージのモジュールを `/tmp/home-manager/modules` で読む。
- **file conflict（collision）** … `home.file` / `xdg.configFile` が同じパスに二重に書こうとした、または既存の dotfile が邪魔をしている → 後述「適用したのに反映されない」も参照。

## nix repl で対話的に潜る

config ツリーを手で辿るのが一番速いことが多い。

```sh
nix repl
nix-repl> :lf .
nix-repl> darwinConfigurations.<name>.config.home-manager.users.<user>.programs.git
nix-repl> darwinConfigurations.<name>.options.home-manager.users.<user>.programs.git.userEmail.type
```

- `config.home-manager.users.<user>.<path>` … マージ後の最終値
- `options.home-manager.users.<user>.<path>` … その option の宣言（`.type` / `.default` / `.description`）

## 世代差分を見る（何が変わったのか）

ビルドは通るが挙動が変わった／壊れたとき、前の世代との差分を取る。

```sh
nix-diff /run/current-system ./result   # 現行 vs これからビルドした system
darwin-rebuild --list-generations
home-manager generations               # home-manager 単体の世代一覧（あれば）
```

`nix-diff` が無ければ `nix store diff-closures /run/current-system ./result` でも依存差分が見える。

## 適用したのに反映されない

switch は成功したが反映されていない。

1. **本当に最終 config に入っているか** → `nix eval .#darwinConfigurations.<name>.config.home-manager.users.<user>.<path>`（`references/verify.md`）。入っていなければ設定／マージの問題。
2. **入っているのに反映されない** → 実装を読む（`references/implementation.md`）。出力先（`~/.config/...` か `~/.foo` か）が想定と違うケース、シェルの再読み込みが要るケースがある。生成物を `cat` / `ls -la ~/.config` で確認。
3. **既存ファイルが邪魔をしている** … home-manager が管理外の実ファイルを上書きできず警告／失敗することがある。対象パスが symlink になっているか `ls -la` で確認し、邪魔な実ファイルを退避する。
4. **activation script が失敗していないか** → switch 時のログを見直す。

## ロールバック

壊したら直前の世代に戻す。

```sh
darwin-rebuild --rollback        # システムごと直前の世代へ
# もしくは特定世代の activate を実行（--list-generations で番号を確認）
```

## 切り分けの順序

1. eval が通るか（`--show-trace`）
2. 値が config に入っているか（`nix eval config.home-manager.users.<user>.<path>`）
3. 生成物が `~` 以下に出ているか（`ls -la ~/.config` / `cat` 出力先）
4. 直前から何が変わったか（`nix-diff`）
