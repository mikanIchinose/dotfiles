[![lint](https://github.com/mikanIchinose/dotfiles/actions/workflows/lint.yml/badge.svg?branch=master&event=push)](https://github.com/mikanIchinose/dotfiles/actions/workflows/lint.yml)

バックアップ作業
- raycastの設定をバックアップ
- android studioの設定をバックアップ
- biscuitの設定をバックアップ
- ~/local をバックアップ

## install

```
ASK_PASS="~/.secret/.ask_pass" /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mikanIchinose/dotfiles/main/__script/install)"
```

## install(nix)

```bash
# 1. copy local directory from SD-card

# 2. run install script
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mikanIchinose/dotfiles/main/install.sh)"
```
