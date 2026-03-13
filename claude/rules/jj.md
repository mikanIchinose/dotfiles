# jujutsu rules

## 判定
- リポジトリルートに `.jj` ディレクトリが存在する場合、そのリポジトリはjj管理下とみなす

## jj管理下のリポジトリでのルール
- **gitコマンドは使わない** → `jj` を使用（`git push` → `jj git push` 等）
- コミットメッセージ: Conventional Commits形式
