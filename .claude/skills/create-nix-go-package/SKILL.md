---
name: create-nix-go-package
description: buildGoModule を使った Go 製ツールの Nix パッケージを作成する。「Go パッケージを追加」「Go ツールをパッケージ化」と依頼された際に使用。
---

## ワークフロー

### 1. テンプレートを一括生成

`init-go.sh` がリリース情報取得・ファイル生成を一括で行う。
ハッシュは `lib.fakeHash` で仮入力される。

```bash
bash .claude/skills/create-nix-go-package/scripts/init-go.sh <pname> <owner> <repo>
```

### 2. flake.nix に登録

`perSystem` と overlay の両方に追加する:

```nix
# perSystem
packages.<pname> = pkgs.callPackage ./nix/packages/<pname> { };

# overlay (overlays-configuration の local packages)
<pname> = final.callPackage ./nix/packages/<pname> { };
```

### 3. git add で Nix に認識させる

flake モードでは Git にトラッキングされていないファイルは参照できない。
`init-go.sh` は自動で `git add` するが、flake.nix の変更も追加する:

```bash
git add nix/packages/<pname> flake.nix
```

### 4. ハッシュを取得（2段階）

ソースビルドでは `src.hash` と `vendorHash` の 2 つのハッシュが必要。
片方ずつ `lib.fakeHash` のまま `nix build` し、エラー出力から正しいハッシュを取得する。

**ステップ 1: src.hash を取得**

```bash
nix build .#<pname> 2>&1 | grep "got:"
```

出力の `got: sha256-...` を `default.nix` の `src.hash` (`lib.fakeHash`) と置き換える。

**ステップ 2: vendorHash を取得**

```bash
nix build .#<pname> 2>&1 | grep "got:"
```

出力の `got: sha256-...` を `default.nix` の `vendorHash` (`lib.fakeHash`) と置き換える。

依存が vendored（`vendor/` ディレクトリがリポジトリに含まれている）場合は `vendorHash = null` とする。

### 5. オプション調整

必要に応じて以下を追加・変更する。

#### ビルド対象の制御

| オプション | 用途 | 例 |
|-----------|------|-----|
| `subPackages` | ビルド対象のパッケージを限定 | `[ "cmd/tool" ]` |
| `excludedPackages` | 除外するパッケージを指定 | `[ "cmd/debug" ]` |

#### ビルドフラグ

| オプション | 用途 | 例 |
|-----------|------|-----|
| `ldflags` | リンカフラグ（バージョン埋め込み等） | `[ "-s" "-w" "-X main.Version=${version}" ]` |
| `tags` | ビルドタグ | `[ "netgo" "osusergo" ]` |

#### CGO の無効化

CGO を使わないパッケージでは明示的に無効化できる:

```nix
CGO_ENABLED = 0;
```

#### 依存関係

| オプション | 用途 | 例 |
|-----------|------|-----|
| `nativeBuildInputs` | ビルド時のみ必要な依存 | `[ pkg-config installShellFiles ]` |
| `buildInputs` | リンク時に必要なライブラリ | `[ openssl ]` |

#### シェル補完のインストール

```nix
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,  # 追加
}:

buildGoModule rec {
  # ...

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd <pname> \
      --bash <("$out/bin/<pname>" completion bash) \
      --zsh  <("$out/bin/<pname>" completion zsh) \
      --fish <("$out/bin/<pname>" completion fish)
  '';
}
```

Go ツールの補完コマンドは `completion`（単数形）が多い。ツールごとに確認すること。

#### その他

| オプション | 用途 |
|-----------|------|
| `doCheck = false` | テストをスキップ（環境依存テストの回避） |
| `proxyVendor = true` | C ライブラリ依存や大文字小文字の衝突がある場合に使用 |

### 6. nix build でビルド確認

```bash
nix build .#<pname> 2>&1
```

失敗した場合はエラーメッセージに応じてオプション調整を行う。

### 7. home-manager.nix に追加

`nix/home-manager.nix` の適切なリストに追加する。

| カテゴリ | 追加先リスト |
|---------|------------|
| 自作・カスタムパッケージ | `selfPackages` |
| CLIユーティリティ | `utility` |
| Go開発ツール | `devtools-go` |
| LSP | `lsp` |
| Linter/Formatter | `linter` |

## 完了チェックリスト

- [ ] `nix eval nixpkgs#<pname>.version` で nixpkgs に既存パッケージがないか確認
- [ ] 既存パッケージがある場合、ユーザーにカスタムパッケージが必要か確認（不要なら home-manager.nix への追加のみ）
- [ ] `init-go.sh` でテンプレート生成
- [ ] `flake.nix` の `perSystem` に追加
- [ ] `flake.nix` の overlay に追加
- [ ] `src.hash` を取得・置換
- [ ] `vendorHash` を取得・置換
- [ ] オプション調整（subPackages, ldflags, CGO_ENABLED 等）
- [ ] `nix build .#<pname>` が成功する
- [ ] `nix/home-manager.nix` の適切なリストに追加
