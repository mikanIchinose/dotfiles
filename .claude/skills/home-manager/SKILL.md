---
name: home-manager
description: |
  home-manager（ユーザー環境の設定）を作り込む。
  「home-manager」「home.nix」「ユーザー環境を nix で設定」「home.packages」「programs.* を nix で」「dotfiles を home-manager で」と依頼された際に使用。
---

home-manager のユーザー層の設定を、ドキュメント・実装の両面から正確に当て、ビルドで検証し、デバッグするためのスキル。

## スコープ

**対象**: home-manager が管理するユーザー環境 — `home.packages` / `home.file` / `home.sessionVariables` / `home.shellAliases` などの `home.*`、`programs.*`（git, zsh, neovim, fzf… のユーザー設定）、`services.*`（ユーザー launchd / systemd ユーザーサービス）、`xdg.*`、`fonts.fontconfig`、`home.activation` など。

**対象外**: nix-darwin が管理するシステム層（`system.defaults`、`homebrew`、システム `launchd.daemons`、`environment.systemPackages` など）。システム全体・root 権限が要る話が出たら「それは nix-darwin の領域」と切り分ける（`nix-darwin` スキルへ）。

## この dotfiles での統合形態（重要）

この repo では home-manager は **nix-darwin のモジュールとして** 統合されている（`flake.nix` の `home-manager.darwinModules.home-manager`）。スタンドアロンの `homeConfigurations` ではない。

- ユーザー設定は `home-manager.users.<username>` 配下に入る。
- 適用は **`darwin-rebuild switch`**（独立した `home-manager switch` は使わない）。
- eval / config 参照のパスは `darwinConfigurations.<name>.config.home-manager.users.<username>.<option>`。
- 設定名とユーザー: `personal`（user `mikan`）, `s34580`（user `s34580`）。
- 各ホストのユーザー設定エントリポイント: `nix/hosts/<host>/home.nix`、共通は `nix/hosts/common/home.nix`。

## セットアップ

まず `scripts/init.sh` を実行し、ソースを `/tmp` に用意する。

```sh
scripts/init.sh
```

- flake.lock の **locked rev に合わせて** クローンするため、読むオプション集合が実機と一致する。
- `/tmp/home-manager` … `modules/`（オプション定義＋実装）, `tests/modules/`（使用例）

## 4つの当たり方

設定を作り込むとき、目的に応じて以下を使い分ける。詳細は各 reference を読む。

| 目的 | reference | 要点 |
|------|-----------|------|
| **ドキュメントにあたる**（標準的な答えを得る） | `references/docs.md` | どのオプションが存在し・型・デフォルトは何かを引く |
| **実装にあたる**（ドキュメント外の使い方を推測する） | `references/implementation.md` | `modules/` 本体と `tests/modules/` を読み、ドキュメントに無い使い方・抜け道を見つける |
| **動作確認する** | `references/verify.md` | switch せずビルド／オプション値を eval して確かめる |
| **デバッグする** | `references/debug.md` | eval エラー・適用結果のズレ・世代差分を切り分ける |

## 基本ワークフロー

1. **ドキュメントにあたる** — まず標準的な答えがあるか確認する（`references/docs.md`）。多くの設定は既存の `programs.*` / `home.*` オプションで完結する。
2. **実装にあたる** — ドキュメントに無い、または曖昧な場合のみソースを読んで推測する（`references/implementation.md`）。
3. **書く** — オプションを設定する。値の型は必ずドキュメント／実装で裏取りする。
4. **動作確認する** — switch する前に `darwin-rebuild build` でビルドが通るか、`nix eval` で値が意図通りかを確かめる（`references/verify.md`）。
5. **詰まったらデバッグ** — `references/debug.md`。

## ソースの場所（接地点）

| パス | 内容 |
|------|------|
| `/tmp/home-manager/modules/programs/` | `programs.*`（git, zsh, neovim, fzf, … 各プログラムのユーザー設定。400 超） |
| `/tmp/home-manager/modules/services/` | `services.*`（ユーザーサービス） |
| `/tmp/home-manager/modules/home-environment.nix` | `home.packages` / `home.sessionVariables` / `home.shellAliases` / `home.sessionPath` など |
| `/tmp/home-manager/modules/files.nix` | `home.file`（任意ファイルの配置） |
| `/tmp/home-manager/modules/misc/` | `xdg`, `fontconfig`, `nix`, `pam`, `news` など雑多なユーザー設定 |
| `/tmp/home-manager/modules/launchd/` | macOS のユーザー launchd エージェント |
| `/tmp/home-manager/tests/modules/` | オプションの使用例（推測の裏取りに最適） |
