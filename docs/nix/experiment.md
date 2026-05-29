# Nix式を評価して理解する実験ノート

このドキュメントでは、dotfilesリポジトリのNix式を評価しながら、何が起きているかを理解します。

## 前提知識

- **Nix式**: 値を返す式。関数、文字列、attribute set などすべてが式
- **Flake**: 再現可能な Nix プロジェクトの単位。`inputs` と `outputs` を持つ
- **Derivation**: ビルドの設計図。ハッシュ化されて `/nix/store` に保存される

## 1. flake.nix の構造を見る

```bash
# flake の情報を表示
nix flake show
```

出力例:
```
├───darwinConfigurations
│   └───mikan: darwin configuration
├───packages
│   ├───aarch64-darwin
│   │   ├───covpeek: package
│   │   └───gwq: package
...
```

**解説**: このflakeは以下を出力している
- `darwinConfigurations.mikan` - macOS システム設定
- `packages.aarch64-darwin.gwq` など - カスタムパッケージ

---

## 2. Nix REPL で flake を読み込む

```bash
nix repl
```

REPL内で:
```nix
# flake を読み込み
:lf .

# outputs の構造を確認（Tab補完が効く）
outputs.<Tab>
```

---

## 3. inputs を評価する

```nix
# inputs の一覧
builtins.attrNames inputs
# => [ "flake-parts" "home-manager" "llm-agents" "nix-darwin" ... ]

# nixpkgs の URL を確認
inputs.nixpkgs.url
# => "github:NixOS/nixpkgs/nixpkgs-unstable"
```

**学び**: `inputs` は依存する外部 flake への参照

---

## 4. pkgs を取得する

```nix
# システムに対応した pkgs を取得
pkgs = import inputs.nixpkgs { system = "aarch64-darwin"; }

# パッケージの存在確認
pkgs.fish
# => «derivation /nix/store/xxx-fish-3.x.x.drv»

# パッケージのメタ情報
pkgs.fish.meta.description
# => "Smart and user-friendly command line shell"
```

---

## 5. カスタムパッケージの derivation を見る

```nix
# gwq パッケージを評価
gwq = outputs.packages.aarch64-darwin.gwq

# derivation の中身
gwq.drvPath
# => "/nix/store/xxx-gwq-0.0.12.drv"

# ビルド後の出力パス（まだビルドしてなければ仮のパス）
gwq.outPath
# => "/nix/store/xxx-gwq-0.0.12"

# メタ情報
gwq.meta.description
# => "Git worktree manager with fuzzy finder"
```

### derivation ファイルの中身を見る

```bash
nix derivation show .#gwq
```

出力例（JSON形式）:
```json
{
  "/nix/store/xxx-gwq-0.0.12.drv": {
    "outputs": { "out": { "path": "/nix/store/yyy-gwq-0.0.12" } },
    "inputSrcs": [...],
    "inputDrvs": {...},
    "builder": "/nix/store/zzz-bash-5.2/bin/bash",
    "args": ["-e", "/nix/store/aaa-builder.sh"],
    "env": {
      "pname": "gwq",
      "version": "0.0.12",
      "src": "/nix/store/bbb-source",
      ...
    }
  }
}
```

**学び**: derivation は「何を入力に」「どのビルダーで」「どんな環境変数で」ビルドするかの設計図

---

## 6. home-manager の設定を評価する

```nix
# darwin configuration を取得
darwin = outputs.darwinConfigurations.mikan

# home-manager で管理されるパッケージ一覧
hm = darwin.config.home-manager.users.mikan
builtins.map (p: p.name) hm.home.packages
# => [ "gwq-0.0.12" "slack-reminder-0.1.0" "fish-3.x.x" ... ]
```

---

## 7. programs モジュールの評価

```nix
# git の設定を見る
hm.programs.git.settings.user.name
# => "mikan"

hm.programs.git.settings.alias
# => { pushf = "push --force-with-lease ..."; ... }

# 有効化されたプログラム
hm.programs.fzf.enable
# => true
```

---

## 8. ファイルリンクの設定を見る

```nix
# home.file で管理されるファイル
builtins.attrNames hm.home.file
# => [ ".claude/CLAUDE.md" ".claude/settings.json" ".emacs.d" ".ideavimrc" ... ]

# 各ファイルのリンク先
hm.home.file.".vimrc".source
# => /nix/store/xxx-dotfiles/home/vimrc (または mkOutOfStoreSymlink の場合は実パス)
```

---

## 9. nix-darwin の macOS 設定を見る

```nix
# Dock の設定
darwin.config.system.defaults.dock
# => { autohide = true; orientation = "bottom"; show-recents = false; tilesize = 30; }

# キーリピート設定
darwin.config.system.defaults.NSGlobalDomain.KeyRepeat
# => 1

# Homebrew で管理される casks
darwin.config.homebrew.casks
# => [ "arc" "google-chrome" "ghostty" ... ]
```

---

## 10. 実際にビルドしてみる

```bash
# gwq パッケージをビルド
nix build .#gwq

# 結果は ./result にシンボリックリンクされる
ls -la result/bin/
# => gwq

# 実行してみる
./result/bin/gwq --version
```

### システム全体をビルド（dry-run）

```bash
# 何がビルドされるか確認（実際にはビルドしない）
darwin-rebuild build --dry-run --flake .
```

---

## 11. overlay の仕組みを理解する

flake.nix の overlay 定義:
```nix
(final: prev: {
  gwq = final.callPackage ./nix/packages/gwq { };
  ...
})
```

```nix
# REPL で overlay を適用した pkgs を作る
pkgs = import inputs.nixpkgs {
  system = "aarch64-darwin";
  overlays = [
    (final: prev: {
      gwq = final.callPackage ./nix/packages/gwq { };
    })
  ];
}

# gwq が使えるようになる
pkgs.gwq.meta.description
# => "Git worktree manager with fuzzy finder"
```

**学び**: overlay は `prev`（元のpkgs）を受け取り、`final`（最終的なpkgs）に追加・上書きする

---

## 12. 便利なデバッグコマンド

```bash
# flake の依存関係ツリー
nix flake metadata

# 特定の式を評価
nix eval .#darwinConfigurations.mikan.config.system.stateVersion
# => 6

# パッケージの依存関係を可視化
nix-store -q --tree $(nix build .#gwq --print-out-paths)
```

---

## まとめ: このリポジトリが出力するもの

| 出力 | 説明 |
|------|------|
| `darwinConfigurations.mikan` | macOS システム全体の設定（nix-darwin + home-manager） |
| `packages.*.gwq` | カスタム Go パッケージ |
| `packages.*.covpeek` | カスタムパッケージ |

```
flake.nix
├── inputs (外部依存)
│   ├── nixpkgs
│   ├── home-manager
│   ├── nix-darwin
│   └── ...
└── outputs
    ├── darwinConfigurations.mikan
    │   ├── nix-darwin.nix (macOS設定, Homebrew, フォント)
    │   └── home-manager.nix (ユーザー設定, パッケージ, dotfiles)
    └── packages (カスタムパッケージ)
```
