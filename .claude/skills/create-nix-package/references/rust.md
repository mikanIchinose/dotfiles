## Rust ソースビルド向けワークフロー

### テンプレートを一括生成

`init-rust.sh` がリリース情報取得・ファイル生成を一括で行う。
ハッシュは `lib.fakeHash` で仮入力される。

```bash
bash .claude/skills/create-nix-package/scripts/init-rust.sh <pname> <owner> <repo>
```

### flake.nix に登録

`perSystem` と overlay の両方に追加する:

```nix
# perSystem
packages.<pname> = pkgs.callPackage ./nix/packages/<pname> { };

# overlay (overlays-configuration の local packages)
<pname> = final.callPackage ./nix/packages/<pname> { };
```

### git add で Nix に認識させる

flake モードでは Git にトラッキングされていないファイルは参照できない。
`init-rust.sh` は自動で `git add` するが、flake.nix の変更も追加する:

```bash
git add nix/packages/<pname> flake.nix
```

### ハッシュを取得（2段階）

ソースビルドでは `src.hash` と `cargoHash` の 2 つのハッシュが必要。
片方ずつ `lib.fakeHash` のまま `nix build` し、エラー出力から正しいハッシュを取得する。

**ステップ 1: src.hash を取得**

```bash
nix build .#<pname> 2>&1 | grep "got:"
```

出力の `got: sha256-...` を `default.nix` の `src.hash` (`lib.fakeHash`) と置き換える。

**ステップ 2: cargoHash を取得**

```bash
nix build .#<pname> 2>&1 | grep "got:"
```

出力の `got: sha256-...` を `default.nix` の `cargoHash` (`lib.fakeHash`) と置き換える。

### オプション調整

必要に応じて以下を追加・変更する。

#### fetchSubmodules

サブモジュールに依存する場合:

```nix
  src = fetchFromGitHub {
    # ...
    fetchSubmodules = true;
  };
```

#### nativeBuildInputs / buildInputs

ビルド時・ランタイム依存がある場合:

```nix
  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
  ];
```

#### シェル補完のインストール

```nix
  nativeBuildInputs = [
    installShellFiles
    which
  ];

  postInstall = ''
    installShellCompletion --cmd <pname> \
      --bash <("$out/bin/<pname>" completions bash) \
      --zsh <("$out/bin/<pname>" completions zsh) \
      --fish <("$out/bin/<pname>" completions fish)
  '';
```

補完コマンドのサブコマンド名はツールごとに異なる（`completions`, `complete`, `--completions` 等）。`<pname> --help` で確認すること。

### nix build でビルド確認

```bash
nix build .#<pname> 2>&1
```

失敗した場合はエラーメッセージに応じてオプション調整を行う。

### home-manager.nix に追加

`nix/home-manager.nix` の適切なリストに追加する。

## 完了チェックリスト

- [ ] `nix eval nixpkgs#<pname>.version` で nixpkgs に既存パッケージがないか確認
- [ ] 既存パッケージがある場合、ユーザーにカスタムパッケージが必要か確認（不要なら home-manager.nix への追加のみ）
- [ ] `init-rust.sh` でテンプレート生成
- [ ] `flake.nix` の `perSystem` に追加
- [ ] `flake.nix` の overlay に追加
- [ ] `src.hash` を取得・置換
- [ ] `cargoHash` を取得・置換
- [ ] オプション調整（fetchSubmodules, nativeBuildInputs 等）
- [ ] `nix build .#<pname>` が成功する
- [ ] `nix/home-manager.nix` の適切なリストに追加
