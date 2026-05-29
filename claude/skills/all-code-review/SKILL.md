---
name: all-code-review
description: レビュー待ちPRを検索し、複数の観点から並列レビューして、結果をmakrdownに出力する
disable-model-invocation: true
allowed-tools: Read(/tmp/review/**)
---

## Initialize
リポジトリが`/tmp/review/`にクローンされているかをチェック
クローンされている -> `git fetch origin`
クローンされていない -> `git clone <repo>`
