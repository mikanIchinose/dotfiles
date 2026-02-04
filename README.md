[![lint](https://github.com/mikanIchinose/dotfiles/actions/workflows/lint.yml/badge.svg?branch=master&event=push)](https://github.com/mikanIchinose/dotfiles/actions/workflows/lint.yml)

## backup

- raycastの設定をバックアップ
- android studioの設定をバックアップ
- ~/local をバックアップ

## install

- restart macOS
- copy local directory from SD-card

```
xcode-select --install
```

install [nix](https://github.com/NixOS/nix-installer)

```
git clone https://github.com/mikanIchinose/dotfiles.git ~/dotfiles
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
cd ~/dotfiles
nix flake update && git add . && sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#mikan
sudo xcodebuild -license accept
```

- install skk dictionary
```
ghq get skk-dev/dict
```

- 外部モニター接続時でも Touch ID で sudo 認証を有効にする
```
sudo defaults write /Library/Preferences/com.apple.security.authorization ignoreArd -bool TRUE
```

## update

```bash
nix flake update && git add . && sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#mikan
```

## garbage collection

```bash
nix-collect-garbage -d
```
