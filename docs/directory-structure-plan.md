# ディレクトリ構造整理計画（A案: XDG準拠型）

## 目標構造

```
dotfiles/
├── config/                     # ~/.config へ symlink（XDG準拠）
│   ├── aerospace/
│   ├── efm-langserver/
│   ├── fish/
│   ├── git/                    # git設定を統合
│   │   ├── config              # 旧 home/gitconfig
│   │   ├── message             # 旧 home/gitmessage
│   │   ├── config.karabiner    # 会社用
│   │   └── config.personal     # 個人用
│   ├── ghostty/
│   ├── lazygit/
│   ├── navi/
│   ├── nvim/
│   ├── starship/
│   └── wezterm/
│
├── config.darwin/              # macOS固有 (~/.config へマージ)
│   ├── karabiner/
│   └── topgrade.toml
│
├── config.linux/               # Linux固有
│
├── home/                       # XDG非対応のdotfiles (~/ へ symlink)
│   ├── bashrc
│   ├── ideavimrc
│   ├── profile
│   ├── vimrc
│   ├── zprofile
│   ├── zshenv
│   └── zshrc
│
├── emacs.d/                    # ~/.emacs.d へ symlink
│
├── bin/                        # 実行可能スクリプト (PATH追加)
│   ├── git-approve             # git extensions
│   ├── git-backup
│   ├── git-desc
│   ├── git-feature
│   ├── git-ff
│   ├── git-wa
│   ├── fetchLGTMImage.ts       # git-approve から呼ばれる
│   └── as-format-changed
│
├── claude/                     # Claude Code グローバル設定
├── .claude/                    # Claude Code ローカル設定（dotfiles用）
├── nix/                        # Nix設定
├── raycast-scripts/            # Raycast用
│
├── CLAUDE.md
├── flake.nix
├── flake.lock
├── fishfile                    # → 将来的に削除（自作スクリプト化）
├── cargofile
└── README.md
```

---

## 移行フェーズ

### 原則

- 各フェーズで `darwin-rebuild switch --flake .` を実行して検証
- 問題があれば `git checkout .` でロールバック可能
- ファイル移動と `home-manager.nix` の更新は同一コミットで行う

---

## Phase 1: 不要ファイルの削除 ✅ 完了

参照がないファイルを削除。darwin-rebuild は不要。

### 削除対象

```bash
# 未使用の設定ディレクトリ
rm -rf home/config/commitizen
rm -rf home/config/gh-dash
rm -rf home/config/markdownlint
rm home/config/stylua.toml
rm home/config/tigrc

# 移行済みのファイル
rm -rf __script
rm home/Brewfile.darwin home/Brewfile.linux
rm home/skhdrc home/yabairc
rm install.sh uninstall.sh

# git/ 内の不要ファイル
rm git/gh-extensions git/ghq-list
```

### 検証

```bash
# 削除したファイルが参照されていないことを確認
darwin-rebuild switch --flake .
```

### コミット

```
chore: remove unused config files
```

---

## Phase 2: nvim のリネーム ✅ 完了済み

> **Note:** このフェーズは完了済み。`nvim_next` は `nvim` に統合され、`home/config/nvim` として存在。
> コミット: `07da4c90 nvim: consolidate nvim_next into nvim`

---

## Phase 3: config/ の作成 ✅ 完了

home/config/ をトップレベルに移動。変更箇所が多いため慎重に。

### 手順

1. ディレクトリを移動
2. home-manager.nix を更新
3. darwin-rebuild で検証

```bash
mv home/config config
mv home/config.darwin config.darwin
mv home/config.linux config.linux
mv aerospace config/aerospace
```

```nix
# home-manager.nix の xdg.configFile を一括更新
xdg.configFile = {
  # 旧: mkLink "home/config/XXX"
  # 新: mkLink "config/XXX"
  "efm-langserver".source = mkLink "config/efm-langserver";
  "fish".source = mkLink "config/fish";
  "lazygit".source = mkLink "config/lazygit";
  "nvim".source = mkLink "config/nvim";
  "navi".source = mkLink "config/navi";
  "starship".source = mkLink "config/starship";
  "wezterm".source = mkLink "config/wezterm";
  "ghostty".source = mkLink "config/ghostty";
  "aerospace".source = mkLink "config/aerospace";
}
// (
  if pkgs.stdenv.isDarwin then
    {
      # 旧: mkLink "home/config.darwin/XXX"
      # 新: mkLink "config.darwin/XXX"
      "karabiner".source = mkLink "config.darwin/karabiner";
      "topgrade.toml".source = mkLink "config.darwin/topgrade.toml";
    }
  else
    { }
);
```

### 検証

```bash
darwin-rebuild switch --flake .
fish --version        # fish 起動確認
ls ~/.config/nvim     # symlink 確認
ls ~/.config/fish
```

### コミット

```
nix: move config directories to top level
```

---

## Phase 4: emacs.d の移動 ✅ 完了

### 手順

```bash
mv home/emacs.d emacs.d
```

```nix
# home-manager.nix
home.file = {
  # 追加
  ".emacs.d".source = mkLink "emacs.d";
};
```

### 検証

```bash
darwin-rebuild switch --flake .
ls -la ~/.emacs.d  # symlink 確認
```

### コミット

```
emacs: move emacs.d to top level
```

---

## Phase 5: bin/ の作成 ✅ 完了

スクリプトを統合し、PATH を更新。

### 手順

```bash
mkdir bin
mv git/extensions/* bin/
mv scripts/as-format-changed bin/
rmdir scripts
```

```nix
# home-manager.nix または zshrc
# PATH を $HOME/dotfiles/bin に統一
```

### 検証

```bash
darwin-rebuild switch --flake .  # sessionPath 更新時のみ

# コマンド動作確認
which git-approve
git-approve  # LGTM 画像取得できるか
which as-format-changed
```

### コミット

```
chore: consolidate scripts into bin/
```

---

## Phase 6: git 設定の統合 ✅ 完了

gitconfig のパス参照を変更するため、慎重に。

### 手順

1. config/git/ ディレクトリを作成
2. ファイルを移動
3. gitconfig 内の includeIf パスを更新
4. home-manager.nix を更新

```bash
mkdir -p config/git
mv home/gitconfig config/git/config
mv home/gitmessage config/git/message
mv git/gitconfig_karabiner config/git/config.karabiner
mv git/gitconfig_personal config/git/config.personal
rmdir git  # extensions は bin/ に移動済み
```

```ini
# config/git/config 内のパスを更新
[includeIf "gitdir:~/ghq/"]
    # 旧: path = ~/dotfiles/git/gitconfig_personal
    path = ~/dotfiles/config/git/config.personal
[includeIf "gitdir:~/ghq-karabiner/"]
    # 旧: path = ~/dotfiles/git/gitconfig_karabiner
    path = ~/dotfiles/config/git/config.karabiner
```

```nix
# home-manager.nix
# home.file から削除
# ".gitconfig".source = mkLink "home/gitconfig";
# ".gitmessage".source = mkLink "home/gitmessage";

# xdg.configFile に追加
"git".source = mkLink "config/git";
```

### 検証

```bash
darwin-rebuild switch --flake .

# git 設定確認
git config --list --show-origin | head -20
git config user.name
git config user.email

# 各リポジトリで includeIf が効いているか
cd ~/ghq/github.com/mikanIchinose/some-repo && git config user.email
cd ~/ghq-karabiner/some-repo && git config user.email
```

### コミット

```
git: consolidate git config into config/git/
```

---

## Phase 7: Nix 統合（別計画）

`nix-integration-plan.md` に従って実施。

- ghfile → programs.gh.extensions
- 環境変数 → home.sessionVariables / home.sessionPath

---

## 削除対象まとめ

| 対象 | Phase | 理由 | 状態 |
|------|-------|------|------|
| `home/config/alacritty/` | - | ghostty使用 | ✅ 削除済み |
| `home/config/kitty/` | - | 未使用 | ✅ 削除済み |
| `home/config/wtf/` | - | 未使用 | ✅ 削除済み |
| `home/config/nvim_next/` | 2 | nvim に統合・リネーム | ✅ 完了済み |
| `home/config/commitizen/` | 1 | 未使用 | ✅ 削除済み |
| `home/config/gh-dash/` | 1 | 未使用 | ✅ 削除済み |
| `home/config/markdownlint/` | 1 | 未使用 | ✅ 削除済み |
| `home/config/stylua.toml` | 1 | 未使用 | ✅ 削除済み |
| `home/config/tigrc` | 1 | 未使用 | ✅ 削除済み |
| `home/Brewfile.darwin` | 1 | nix-darwin で管理 | ✅ 削除済み |
| `home/Brewfile.linux` | 1 | nix-darwin で管理 | ✅ 削除済み |
| `home/skhdrc` | 1 | aerospace に移行済み | ✅ 削除済み |
| `home/yabairc` | 1 | aerospace に移行済み | ✅ 削除済み |
| `__script/` | 1 | Nix管理に移行済み | ✅ 削除済み |
| `install.sh` | 1 | Nix管理に移行済み | ✅ 削除済み |
| `uninstall.sh` | 1 | Nix管理に移行済み | ✅ 削除済み |
| `git/gh-extensions` | 1 | ghfile と重複 | ✅ 削除済み |
| `git/ghq-list` | 1 | 未使用 | ✅ 削除済み |
| `git/` | 6 | config/git/ と bin/ に分離 | ✅ 完了 |
| `scripts/` | 5 | bin/ に統合 | ✅ 完了 |

---

## ロールバック手順

各フェーズで問題が発生した場合：

```bash
# 未コミットの変更を取り消し
git checkout .
git clean -fd

# 直前のコミットを取り消し（必要な場合）
git reset --hard HEAD~1

# Nix 設定を再適用
darwin-rebuild switch --flake .
```

---

## 備考

- `config/git/config` は XDG 準拠で `~/.config/git/config` として認識される
- `fetchLGTMImage.ts` は `git-approve` から `$SCRIPT_DIR` 経由で参照されるため、同じ `bin/` に配置
- 各フェーズは独立してコミット可能
- 問題発生時は該当フェーズのみロールバック
