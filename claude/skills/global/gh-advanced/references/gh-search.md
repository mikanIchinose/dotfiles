# gh search コマンド

GitHub 検索 API への直接アクセス。GitHub 全体を対象に検索できる。

**検索クエリ構文:** [search-query.md](./search-query.md)

## 基本コマンド

```bash
# Issue 検索
gh search issues "bug" --state open --label "help wanted"

# PR 検索
gh search prs "refactor" --state merged --author @me

# コード検索
gh search code "pattern" --repo owner/repo
gh search code "func main" --language go --filename main.go

# リポジトリ検索
gh search repos "cli tool" --language rust --stars ">1000"

# コミット検索
gh search commits "fix bug" --author username --repo owner/repo
```

## 主要オプション

| オプション | 説明 |
|-----------|------|
| `--repo` | リポジトリを指定 |
| `--owner` | オーナー（ユーザー/組織）を指定 |
| `--language` | 言語を指定 |
| `--limit` | 取得件数を制限 |
| `--json` | JSON 形式で出力 |
| `--jq` | jq でフィルタリング |

## gh search vs gh pr/issue list

| | `gh search` | `gh pr/issue list --search` |
|---|-------------|---------------------------|
| 対象範囲 | GitHub 全体 | 現在のリポジトリ |
| 用途 | 広範な検索 | リポジトリ内の絞り込み |

```bash
# GitHub 全体から検索
gh search prs "review-requested:@me is:open"

# 現在のリポジトリ内で検索
gh pr list --search "review-requested:@me"
```

## 除外検索

ハイフン付きクエリは `--` で区切る:

```bash
gh search issues -- "my-query -label:bug"
```
