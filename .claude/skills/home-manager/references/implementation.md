# 実装にあたる（ドキュメント外の使い方を推測する）

目的: ドキュメントには書いていないが **そういう使い方もできる** ことを、ソースから推測する。
「公式オプションが無い」「`description` が曖昧」「想定外の値を渡したい」ときに潜る。

## モジュールの読み方

各モジュールは `options`（宣言）と `config`（実装）に分かれる。**`config` 側を読むと、そのオプションが実機で何を生成するかが分かる**。

```sh
# あるモジュール全体を読む（宣言＋実装）
cat /tmp/home-manager/modules/programs/git.nix
```

読み取るポイント:
- `config = mkIf cfg.enable { ... }` — 有効時に何を出力するか
- `home.file` / `xdg.configFile` として最終的にどの設定ファイルが `~` 以下に書き出されるか
- `home.packages` に何のパッケージが追加されるか（`programs.foo.enable` が暗黙に入れる依存）
- `home.activation.*` として何のスクリプトが走るか
- ユーザー launchd / systemd ユニットとして何が書き出されるか

→ これが分かると「ドキュメントに無い設定も同じ仕組みで渡せるはず」と推測できる。

## tests/modules/ は使用例の宝庫

`/tmp/home-manager/tests/modules/` に、各機能の **実際の設定例と期待される出力** がある。ドキュメントより具体的で、想定された使い方が読み取れる。

```sh
ls /tmp/home-manager/tests/modules/programs/
cat /tmp/home-manager/tests/modules/programs/git/*.nix
cat /tmp/home-manager/tests/modules/home-environment/*.nix
ls /tmp/home-manager/tests/modules/files/
```

## 代表的な抜け道（escape hatch）

公式オプションが無いときの逃げ道。いずれもソースで実装を確認してから使う。

| やりたいこと | 抜け道 | 定義 |
|--------------|--------|------|
| プログラムに公式オプションの無い設定を足す | `programs.<name>.extraConfig` / `extraOptions`（プログラムによる） | `modules/programs/<name>.nix` |
| 任意のファイルを home に置く | `home.file.<path>.{text,source}` | `modules/files.nix` |
| `~/.config` に任意ファイルを置く | `xdg.configFile.<path>.{text,source}` | `modules/misc/xdg/` |
| 適用時に任意のシェルを走らせる | `home.activation.<name> = lib.hm.dag.entryAfter [...] "..."` | `modules/home-environment.nix` |
| 環境変数 / PATH を足す | `home.sessionVariables` / `home.sessionPath` | `modules/home-environment.nix` |
| 任意のユーザー launchd エージェント | `launchd.agents.*` | `modules/launchd/` |

## 型の実際の許容範囲を推測する

`type` の定義を辿ると、ドキュメントの説明より広い値が通ることがある。

```sh
grep -rn "mkOption\|types\." /tmp/home-manager/modules/programs/git.nix | head
```

- `types.nullOr X` … `null` で「設定しない」を意味する。
- `types.attrsOf` / `submodule` … 自由なキーや構造を渡せる（`extraConfig` 等が典型）。
- `lines` / `lib.hm.dag.entryAfter` … テキストブロックや順序付き activation。
- 推測した使い方は **必ず `references/verify.md` でビルド／eval して裏取りする**。

## home-manager ライブラリ（lib.hm）

home-manager 固有のヘルパーが `lib.hm.*` にある。activation の DAG、`gvariant`、`generators` など。

```sh
ls /tmp/home-manager/modules/lib/
grep -rn "hm.dag\|hm.gvariant\|maybeEnv" /tmp/home-manager/modules/lib/ | head
```
