## dotfiles Structure

```
dotfiles/
├── flake.nix                # Nix flake エントリポイント
├── flake.lock
├── nix/
│   ├── home-manager.nix     # home-manager 設定
│   ├── nix-darwin.nix       # macOS 用 nix-darwin 設定
│   ├── node2nix/            # Node.js パッケージ
│   └── packages/            # カスタム Nix パッケージ
├── home/
│   ├── config/              # ツール設定 (~/.config へ symlink)
│   ├── config.darwin/       # macOS 固有設定
│   ├── config.linux/        # Linux 固有設定
│   └── emacs.d/
├── git/                     # Git 設定
├── aerospace/               # AeroSpace (macOS WM) 設定
├── claude/                  # Claude Code 設定
├── __script/                # ユーティリティスクリプト
├── raycast-scripts/         # Raycast スクリプト
├── .github/workflows/       # CI 設定
├── fishfile                 # Fish プラグインリスト
└── renovate.json            # Renovate 設定
```

- **Nix** で環境管理（nix-darwin + home-manager）
- **home/config/** 配下のツール設定を `~/.config` へ symlink
- カスタムパッケージは `nix/packages/` で管理

## Version control
### message format

```
<scope>: <description>

[optional body]

[optional footer]
```

#### scope（必須）
- 変更対象のツール名をそのまま使用
- 例: `nix`, `fish`, `nvim`, `git`, `ghostty`, `ghq`, `gh`, `claude`, etc.
- 特殊スコープ:
  - `ci` - GitHub Actions など CI 関連
  - `docs` - README, ドキュメント
  - `chore` - リポジトリ全体・分類不能なもの
- 複数スコープにまたがる場合はコミットを分ける

#### description（必須）
- 小文字の動詞で始める（命令形）
- 主な動詞: `add`, `remove`, `update`, `fix`, `refactor`, `migrate`
- 末尾にピリオドを付けない

#### body / footer（任意）
- 1行空けて記述
- 破壊的変更: `BREAKING CHANGE: 説明`

#### 例

```
ghostty: add keybinding for split pane
```

```
gh: update aliases
```

```
nix: update flake.lock
```
