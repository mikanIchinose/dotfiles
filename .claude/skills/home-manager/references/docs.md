# ドキュメントにあたる（標準的な答えを得る）

目的: 「どのオプションが存在し、型・デフォルト・説明は何か」という **想定された正攻法** を引く。

## 引き方の優先順位

### 1. ピン版ソースの description を grep（最も信頼できる）

オプションは `modules/**.nix` に `mkOption` の `description` 付きで定義されている。これが実機と一致する一次情報。

```sh
# プログラム単位で定義ファイルを探す
ls /tmp/home-manager/modules/programs/ | grep -i git
# あるオプションの定義（型・default・description）を読む
grep -rn "enable\|userName\|userEmail" /tmp/home-manager/modules/programs/git.nix
# キーワードで横断検索
grep -rn "sessionVariables" /tmp/home-manager/modules/home-environment.nix
```

`mkOption` ブロックから読み取るもの:
- `type` — 許容される値（`types.nullOr types.bool`, `types.attrsOf types.str` 等）
- `default` — 未設定時の挙動
- `example` — 推奨される書き方
- `description` — 何を意味するか

### 2. オプション検索サイト（一覧性が高い）

存在するオプションを横断的に探したいとき。**ただし表示バージョンがピン版とずれることがある** ので、最終的な型は必ずソースで裏取りする。

- home-manager 公式マニュアル（Appendix A: Configuration Options）
- mynixos.com の home-manager options（検索可能）

### 3. `man home-configuration.nix`（インストール済み環境から照会）

home-manager を導入済みなら、全オプションを man で引ける。ピン版とずれる可能性があるので最終確認はソースで行う。

```sh
man home-configuration.nix
```

## カテゴリ別の置き場所

| 設定したいもの | 見るディレクトリ／ファイル |
|----------------|------------------|
| 各プログラムのユーザー設定（git, zsh, neovim, fzf, starship…） | `modules/programs/<name>.nix` |
| ユーザーサービス（ユーザー launchd / systemd） | `modules/services/<name>.nix` |
| ユーザーにインストールするパッケージ | `modules/home-environment.nix`（`home.packages`） |
| 環境変数 / PATH / エイリアス | `modules/home-environment.nix`（`home.sessionVariables` / `sessionPath` / `shellAliases`） |
| 任意ファイルを home に配置 | `modules/files.nix`（`home.file`） |
| XDG ディレクトリ / `~/.config` ファイル | `modules/misc/xdg/`（`xdg.configFile` 等） |
| フォント | `modules/misc/fontconfig.nix`（`fonts.fontconfig`） |
| 適用時に走らせる処理 | `home-environment.nix`（`home.activation`） |

## 判断

- ここで型・デフォルト・意味が確定し、既存オプションで足りるなら **そのまま書く**。
- 「ドキュメントに無いが実現したい」「型が曖昧」「想定外の値を渡したい」なら `references/implementation.md` へ。
