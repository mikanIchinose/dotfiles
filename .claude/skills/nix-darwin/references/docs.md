# ドキュメントにあたる（標準的な答えを得る）

目的: 「どのオプションが存在し、型・デフォルト・説明は何か」という **想定された正攻法** を引く。

## 引き方の優先順位

### 1. ピン版ソースの description を grep（最も信頼できる）

オプションは `modules/**.nix` に `mkOption` の `description` 付きで定義されている。これが実機と一致する一次情報。

```sh
# オプション名・キーワードで定義箇所を探す
grep -rn "autohide" /tmp/nix-darwin/modules/system/defaults/
# あるオプションの定義（型・default・description）を読む
grep -rn "system.defaults.dock.autohide " /tmp/nix-darwin/modules/
```

`mkOption` ブロックから読み取るもの:
- `type` — 許容される値（`types.nullOr types.bool` 等）
- `default` — 未設定時の挙動
- `example` — 推奨される書き方
- `description` — 何を意味するか

### 2. オプション検索サイト（一覧性が高い）

存在するオプションを横断的に探したいとき。**ただし表示バージョンがピン版とずれることがある** ので、最終的な型は必ずソースで裏取りする。

- nix-darwin 公式マニュアル（オプション索引、`opt-` プレフィックス）
- mynixos.com の nix-darwin options（検索可能）

### 3. `darwin-option`（インストール済みシステムから照会）

`darwin-option <option.path>` でオプションの値・型・説明をライブ照会できる。
※ flake のみの環境（`<darwin>` が NIX_PATH に無い）では動かないことがある。その場合は 1 か、`references/verify.md` の `nix eval` を使う。

```sh
darwin-option system.defaults.dock.autohide
```

## カテゴリ別の置き場所

| 設定したいもの | 見るディレクトリ |
|----------------|------------------|
| Dock / Finder / トラックパッド / キーボード等 macOS defaults | `modules/system/defaults/` |
| 任意の defaults ドメイン（未定義のもの） | `modules/system/defaults/CustomPreferences.nix`（`references/implementation.md` 参照） |
| Homebrew (brews/casks/taps/onActivation) | `modules/homebrew.nix` |
| launchd デーモン/エージェント | `modules/launchd/` |
| services（プリインのサービス） | `modules/services/` |
| フォント | `modules/fonts/` |
| security（pam, sudo touchid 等） | `modules/security/` |
| networking | `modules/networking/` |
| programs（システム全体の program） | `modules/programs/` |

## 判断

- ここで型・デフォルト・意味が確定し、既存オプションで足りるなら **そのまま書く**。
- 「ドキュメントに無いが実現したい」「型が曖昧」「想定外の値を渡したい」なら `references/implementation.md` へ。
