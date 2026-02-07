---
name: fetching-gh-comments
description: GitHub PR/Issue のコメントを取得する。URLやPR番号を指定してコメントを取得したいときに使用。trigger「コメント取得」「コメントを見せて」「fetch comment」「get comment」「https://github.com/.../pull/N#discussion_r...」「https://github.com/.../issues/N#issuecomment-...」
---

GitHub PR/Issue のコメントを `gh api` で取得するスキル。

## URL からコメントを取得

ARGUMENTS に GitHub URL が渡された場合、URL のフラグメントからコメント種別と ID を判別して取得する。

### URL パターンと API エンドポイントの対応

| URL フラグメント | 種別 | API エンドポイント |
|---|---|---|
| `#discussion_r{id}` | PR レビューコメント | `repos/:owner/:repo/pulls/comments/{id}` |
| `#issuecomment-{id}` | 通常コメント (Issue/PR) | `repos/:owner/:repo/issues/comments/{id}` |
| `#pullrequestreview-{id}` | PR レビュー | `repos/:owner/:repo/pulls/{pr_number}/reviews/{id}` |

### 手順

1. URL からフラグメント部分を解析し、上記テーブルに照合
2. `gh api` で取得（リポジトリ内なら `:owner/:repo` を使用、それ以外は URL から `{owner}/{repo}` を抽出）
3. `--jq '.body'` で本文のみ出力

```bash
# PR レビューコメント
gh api repos/:owner/:repo/pulls/comments/{id} --jq '.body'

# 通常コメント (Issue/PR 共通)
gh api repos/:owner/:repo/issues/comments/{id} --jq '.body'

# PR レビュー
gh api repos/:owner/:repo/pulls/{pr_number}/reviews/{id} --jq '.body'
```

## PR/Issue のコメント一覧を取得

ARGUMENTS に PR 番号や Issue 番号が渡された場合、コメント一覧を取得する。

```bash
# PR の通常コメント一覧
gh api repos/:owner/:repo/issues/{number}/comments --jq '.[] | {id, user: .user.login, body}'

# PR のレビューコメント一覧
gh api repos/:owner/:repo/pulls/{number}/comments --jq '.[] | {id, user: .user.login, path, body}'

# Issue のコメント一覧
gh api repos/:owner/:repo/issues/{number}/comments --jq '.[] | {id, user: .user.login, body}'
```

## リポジトリの判別

- 現在のディレクトリが対象リポジトリの場合: `:owner/:repo` を使用
- 別リポジトリの場合: URL から `{owner}/{repo}` を抽出して使用

## 出力フォーマット

取得結果は以下の形式でユーザーに表示する:

```
**{user}** のコメント ({created_at}):

{body}
```

一覧の場合は各コメントを区切り線で分ける。
