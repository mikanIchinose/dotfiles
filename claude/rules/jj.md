# jujutsu rules

<detection>
## 判定

リポジトリルートに `.jj` ディレクトリが存在する場合、そのリポジトリは jj 管理下とみなす。
</detection>

<rules>
## jj 管理下のリポジトリでのルール

- **git コマンドを使わず `jj` を使う** — jj は git のインデックスを介さず作業コピーを直接
  コミットとして扱うため、git コマンドを混ぜると jj 側の状態と食い違う。
  対応例: `git push` → `jj git push`、`git log` → `jj log`、`git diff` → `jj diff`
- コミットメッセージは Conventional Commits 形式で書く
</rules>
