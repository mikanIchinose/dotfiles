# 実装にあたる（ドキュメント外の使い方を推測する）

目的: ドキュメントには書いていないが **そういう使い方もできる** ことを、ソースから推測する。
「公式オプションが無い」「`description` が曖昧」「想定外の値を渡したい」ときに潜る。

## モジュールの読み方

各モジュールは `options`（宣言）と `config`（実装）に分かれる。**`config` 側を読むと、そのオプションが実機で何を生成するかが分かる**。

```sh
# あるモジュール全体を読む（宣言＋実装）
cat /tmp/nix-darwin/modules/system/defaults-write.nix
```

読み取るポイント:
- `config = mkIf cfg.enable { ... }` — 有効時に何を出力するか
- macOS defaults 系なら、最終的にどの `defaults write <domain> <key> <value>` に変換されるか
- activation script（`system.activationScripts.*`）として何が走るか
- launchd plist として何が書き出されるか

→ これが分かると「ドキュメントに無いキーも同じ仕組みで渡せるはず」と推測できる。

## tests/ は使用例の宝庫

`/tmp/nix-darwin/tests/*.nix` に、各機能の **実際の設定例と期待される出力** がある。ドキュメントより具体的で、想定された使い方が読み取れる。

```sh
ls /tmp/nix-darwin/tests/
cat /tmp/nix-darwin/tests/homebrew.nix
cat /tmp/nix-darwin/tests/launchd-daemons.nix
cat /tmp/nix-darwin/tests/activation-scripts.nix
```

## 代表的な抜け道（escape hatch）

公式オプションが無いときの逃げ道。いずれもソースで実装を確認してから使う。

| やりたいこと | 抜け道 | 定義 |
|--------------|--------|------|
| 未定義の defaults ドメイン/キーを書く | `system.defaults.CustomUserPreferences` / `CustomSystemPreferences` | `modules/system/defaults/CustomPreferences.nix` |
| 適用時に任意のシェルを走らせる | `system.activationScripts.<name>.text` | `modules/system/activation-scripts.nix` |
| 任意の launchd デーモン/エージェント | `launchd.daemons.*` / `launchd.user.agents.*` | `modules/launchd/` |
| 任意の `/etc` ファイル | `environment.etc.*` | `modules/environment/` |
| Homebrew の素の挙動 | `homebrew.*`（masApps, whalebrews, extraConfig 等） | `modules/homebrew.nix` |

## 型の実際の許容範囲を推測する

`type` の定義を辿ると、ドキュメントの説明より広い値が通ることがある。

```sh
# 型エイリアスや submodule の定義を辿る
grep -rn "floatWithDeprecationError\|mkOption" /tmp/nix-darwin/modules/system/defaults/dock.nix
```

- `types.nullOr X` … `null` で「設定しない」を意味する（多くの defaults オプションがこれ）
- `types.attrsOf` / `submodule` … 自由なキーや構造を渡せる
- 推測した使い方は **必ず `references/verify.md` でビルド／eval して裏取りする**。

## nix-homebrew 層

tap の trust/bootstrap は nix-darwin ではなく nix-homebrew 側。

```sh
grep -rn "mkOption\|trust\|taps" /tmp/nix-homebrew/ | head
```

`nix-homebrew.enable` / `nix-homebrew.user` / `nix-homebrew.taps` / `nix-homebrew.mutableTaps` などの宣言を読む。
