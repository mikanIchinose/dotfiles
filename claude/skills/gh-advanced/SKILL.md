---
name: gh-advanced
description: gh CLI の高度な使い方、使用頻度の低いサブコマンド、便利なオプションを提供。trigger「gh の使い方」「GitHub API を叩きたい」「gh」「use gh」
---

gh CLI の高度な使い方とあまり知られていない便利な機能のリファレンス。

## リファレンス

| カテゴリ | 説明 |
|---------|------|
| [gh api](./references/gh-api.md) | REST API / GraphQL 直接アクセス |
| [gh search](./references/gh-search.md) | GitHub 全体の検索 |
| [検索クエリ](./references/search-query.md) | 検索クエリ修飾子 |
| [gh pr](./references/gh-pr.md) | 高度な PR 操作 |
| [gh issue](./references/gh-issue.md) | 高度な Issue 操作 |
| [gh actions](./references/gh-actions.md) | run / workflow / cache |
| [gh release](./references/gh-release.md) | リリース管理 |
| [gh secrets](./references/gh-secrets.md) | secret / variable 管理 |
| [gh auth](./references/gh-auth.md) | 認証・グローバルオプション |
| [その他](./references/gh-misc.md) | project / extension / alias / codespace / gist 等 |

## クイックリファレンス

### API アクセス

```bash
gh api repos/{owner}/{repo}/pulls --jq '.[].title'
gh api graphql -f query='{ viewer { login } }'
```

### 検索

```bash
gh search prs "review-requested:@me is:open"
gh pr list --search "review:approved draft:false"
```

### Actions

```bash
gh run list --status failure
gh workflow run deploy.yml -f env=prod
```

### PR / Issue

```bash
gh pr checks {number} --watch --fail-fast
gh issue list --search "no:assignee label:bug"
```

### リリース

```bash
gh release create v1.0.0 --generate-notes ./dist/*.tar.gz
```

### シークレット

```bash
gh secret set API_KEY --env production
gh variable set -f .env
```
