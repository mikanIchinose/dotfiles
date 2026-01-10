[![lint](https://github.com/mikanIchinose/dotfiles/actions/workflows/lint.yml/badge.svg?branch=master&event=push)](https://github.com/mikanIchinose/dotfiles/actions/workflows/lint.yml)

## backup

- raycastの設定をバックアップ
- android studioの設定をバックアップ
- ~/local をバックアップ

## install

- restart macOS
- copy local directory from SD-card

```
xcode-select --install && \
softwareupdate --install-rosetta && \
git clone https://github.com/mikanIchinose/dotfiles.git ~/dotfiles && \
sudo xcodebuild -license accept
```

- install nix from https://docs.determinate.systems/

```
go install github.com/rhysd/dotfiles@latest && \
~/go/bin/dotfiles link ~/dotfiles
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
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#mikan
```
