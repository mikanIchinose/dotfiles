---
name: nix-darwin
description: |
  nix-darwin（macOS のシステム設定）を作り込む。
  「nix-darwin」「darwin の設定」「macOS を nix で設定」「darwin-rebuild」「system.defaults」「homebrew を nix で」と依頼された際に使用。
---

nix-darwin のシステム層の設定を、ドキュメント・実装の両面から正確に当て、ビルドで検証し、デバッグするためのスキル。

## スコープ

**対象**: nix-darwin が提供するシステム層 — `system.defaults`（macOS defaults）、`homebrew`、`launchd`、`services`、`fonts`、`security`、`networking`、`programs`、`environment.systemPackages` など。

**対象外**: home-manager が管理するユーザー環境（プログラム設定・dotfiles・シェル・`home.packages`）。`home.nix` 側の話が出たら「それは home-manager の領域」と切り分ける。

## セットアップ

まず `scripts/init.sh` を実行し、ソースを `/tmp` に用意する。

```sh
scripts/init.sh
```

- flake.lock の **locked rev に合わせて** クローンするため、読むオプション集合が実機と一致する。
- `/tmp/nix-darwin` … `modules/`（オプション定義＋実装）, `tests/`（使用例）
- `/tmp/nix-homebrew` … homebrew の tap trust/bootstrap 層

## 4つの当たり方

設定を作り込むとき、目的に応じて以下を使い分ける。詳細は各 reference を読む。

| 目的 | reference | 要点 |
|------|-----------|------|
| **ドキュメントにあたる**（標準的な答えを得る） | `references/docs.md` | どのオプションが存在し・型・デフォルトは何かを引く |
| **実装にあたる**（ドキュメント外の使い方を推測する） | `references/implementation.md` | `modules/` 本体と `tests/` を読み、ドキュメントに無い使い方・抜け道を見つける |
| **動作確認する** | `references/verify.md` | switch せずビルド／オプション値を eval して確かめる |
| **デバッグする** | `references/debug.md` | eval エラー・適用結果のズレ・世代差分を切り分ける |

## 基本ワークフロー

1. **ドキュメントにあたる** — まず標準的な答えがあるか確認する（`references/docs.md`）。多くの設定は既存オプションで完結する。
2. **実装にあたる** — ドキュメントに無い、または曖昧な場合のみソースを読んで推測する（`references/implementation.md`）。
3. **書く** — オプションを設定する。値の型は必ずドキュメント／実装で裏取りする。
4. **動作確認する** — switch する前に `darwin-rebuild build` でビルドが通るか、`nix eval` で値が意図通りかを確かめる（`references/verify.md`）。
5. **詰まったらデバッグ** — `references/debug.md`。

## ソースの場所（接地点）

| パス | 内容 |
|------|------|
| `/tmp/nix-darwin/modules/system/defaults/` | macOS defaults 系オプション（Dock, Finder, NSGlobalDomain, trackpad…） |
| `/tmp/nix-darwin/modules/` | 全モジュール（homebrew.nix, launchd/, services/, security/, fonts/, networking/, programs/） |
| `/tmp/nix-darwin/tests/` | オプションの使用例（推測の裏取りに最適） |
| `/tmp/nix-homebrew/` | `nix-homebrew.*` オプション（tap trust, bootstrap） |
