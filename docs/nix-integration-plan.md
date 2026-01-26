# Nix統合計画

dotfilesの設定をNix（home-manager）に統合し、管理を一元化する。

## タスク

### 1. ghfile → programs.gh.extensions に統合

**現状**
- `ghfile` で gh 拡張を管理
- `gh-poi` は既に `programs.gh.extensions` に統合済み
- `gh-switch-issue`（自作）が未統合

**対応**
- [ ] `gh-switch-issue` を `nix/packages/` にパッケージ化、または fetchFromGitHub で取得
- [ ] `programs.gh.extensions` に追加
- [ ] ghfile を削除

### 2. zshrc の環境変数 → home.sessionVariables / home.sessionPath

**現状**
zshrc で PATH や環境変数を設定している。

**移行対象**
```
home.sessionVariables:
  - JAVA_HOME

home.sessionPath:
  - $HOME/dotfiles/git/extensions
  - $HOME/dotfiles/scripts
  - $HOME/go/bin
  - $HOME/.pub-cache/bin
  - $HOME/.npm-global/bin
  - $HOME/.claude/local
  - $HOME/.fvm_flutter/bin
  - $HOME/.local/bin
  - $BUN_INSTALL/bin
```

**zshrc に残すもの**
- `.secrets.sh` の読み込み
- `.ghcup/env`（Haskell）
- `.dart-cli-completion`（Dart）
- fish への exec（現状維持）

**対応**
- [ ] `home.sessionVariables` に `JAVA_HOME` を追加
- [ ] `home.sessionPath` に上記パスを追加
- [ ] zshrc から移行した行を削除

### 3. 不要な設定ファイルの削除

**削除対象**
- [ ] `home/config/alacritty/` - ghostty に移行済み
- [ ] `home/config/kitty/` - 使用していない
- [ ] `home/config/wtf/` - 使用していない

### 4. nvim 設定のリネーム

**現状**
- `home/config/nvim/` - 旧設定（未使用）
- `home/config/nvim_next/` - 現在使用中

**対応**
- [ ] `home/config/nvim/` を削除
- [ ] `home/config/nvim_next/` を `home/config/nvim/` にリネーム
- [ ] `home-manager.nix` の xdg.configFile を更新（`nvim_next` → `nvim`）

## 対象外（今回はやらない）

| 項目 | 理由 |
|------|------|
| fishfile | プラグインをやめて自作スクリプト化予定 |
| cargofile | そのまま維持 |
| gitconfig | includeIf の条件分岐が複雑、symlink維持 |

## 備考

- 変更後は `darwin-rebuild switch --flake .` で適用
- 環境変数の変更はシェル再起動が必要
