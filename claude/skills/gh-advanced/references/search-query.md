# GitHub 検索クエリ修飾子リファレンス

## 目次

- [Issue / PR 検索修飾子](#issue--pr-検索修飾子)
- [検索場所の指定](#検索場所の指定)
- [日付で絞り込み](#日付で絞り込みiso8601形式-yyyy-mm-dd)
- [リポジトリ・組織の絞り込み](#リポジトリ組織の絞り込み)
- [コード検索修飾子](#コード検索修飾子)
- [リポジトリ検索修飾子](#リポジトリ検索修飾子)
- [ブール演算子](#ブール演算子)
- [正規表現とワイルドカード](#正規表現とワイルドカード)
- [実用的な検索例](#実用的な検索例)

---

以下のコマンドで使用可能:
- `gh search issues` / `gh search prs` / `gh search code` / `gh search repos`
- `gh issue list --search`
- `gh pr list --search`

**公式ドキュメント:**
- [Searching issues and pull requests](https://docs.github.com/en/search-github/searching-on-github/searching-issues-and-pull-requests)
- [Understanding GitHub Code Search syntax](https://docs.github.com/en/search-github/github-code-search/understanding-github-code-search-syntax)
- [Understanding the search syntax](https://docs.github.com/en/search-github/getting-started-with-searching-on-github/understanding-the-search-syntax)
- [Filtering and searching issues and pull requests](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/filtering-and-searching-issues-and-pull-requests)

---

## Issue / PR 検索修飾子

| 修飾子 | 説明 | 例 |
|--------|------|-----|
| `is:issue` / `is:pr` | タイプで絞り込み | `is:pr is:open` |
| `is:open` / `is:closed` | 状態で絞り込み | `is:closed is:pr` |
| `is:merged` / `is:unmerged` | マージ状態 | `is:merged author:@me` |
| `is:draft` | ドラフト PR | `is:draft is:open` |
| `is:public` / `is:private` | リポジトリの可視性 | `is:private is:issue` |
| `author:USER` | 作成者 | `author:octocat` |
| `assignee:USER` | 担当者 | `assignee:@me` |
| `mentions:USER` | メンションされた | `mentions:@me` |
| `commenter:USER` | コメントした | `commenter:octocat` |
| `involves:USER` | 関与（作成/担当/コメント） | `involves:@me` |
| `team:ORG/TEAM` | チームメンション | `team:github/support` |
| `label:LABEL` | ラベル | `label:bug label:urgent` |
| `label:LABEL,LABEL` | ラベル（OR） | `label:bug,enhancement` |
| `milestone:NAME` | マイルストーン | `milestone:"v1.0"` |
| `project:NUMBER` | プロジェクト | `project:1` |
| `review:STATE` | レビュー状態 | `review:approved`, `review:changes_requested`, `review:required`, `review:none` |
| `reviewed-by:USER` | レビュアー | `reviewed-by:@me` |
| `review-requested:USER` | レビューリクエスト先 | `review-requested:@me` |
| `status:pending` / `success` / `failure` | CI ステータス | `status:failure is:open` |
| `draft:true` / `draft:false` | ドラフト状態 | `draft:false is:pr` |
| `linked:pr` / `linked:issue` | リンクあり | `is:issue linked:pr` |
| `reason:completed` / `"not planned"` | クローズ理由 | `is:closed reason:"not planned"` |
| `-label:LABEL` | ラベルなし（除外） | `-label:wontfix` |
| `no:label` | ラベルがない | `is:open no:label` |
| `no:assignee` | 担当者がない | `is:open no:assignee` |
| `no:milestone` | マイルストーンがない | `is:open no:milestone` |
| `no:project` | プロジェクトがない | `is:open no:project` |

## 検索場所の指定

| 修飾子 | 説明 | 例 |
|--------|------|-----|
| `in:title` | タイトル内 | `error in:title` |
| `in:body` | 本文内 | `TODO in:body` |
| `in:comments` | コメント内 | `workaround in:comments` |
| `in:title,body` | タイトルまたは本文 | `bug in:title,body` |

## 日付で絞り込み（ISO8601形式: YYYY-MM-DD）

| 修飾子 | 説明 | 例 |
|--------|------|-----|
| `created:DATE` | 作成日 | `created:>2024-01-01` |
| `updated:DATE` | 更新日 | `updated:>=2024-06-01` |
| `closed:DATE` | クローズ日 | `closed:<2024-01-01` |
| `merged:DATE` | マージ日 | `merged:2024-01-01..2024-12-31` |

日付の演算子: `>`, `>=`, `<`, `<=`, `..`（範囲）

## リポジトリ・組織の絞り込み

| 修飾子 | 説明 | 例 |
|--------|------|-----|
| `repo:OWNER/REPO` | 特定リポジトリ | `repo:cli/cli` |
| `org:ORG` | 組織全体 | `org:github` |
| `user:USER` | ユーザーの全リポジトリ | `user:octocat` |

## コード検索修飾子

| 修飾子 | 説明 | 例 |
|--------|------|-----|
| `repo:OWNER/REPO` | リポジトリ指定（必須） | `repo:cli/cli` |
| `org:ORG` | 組織内を検索 | `org:github` |
| `language:LANG` | 言語 | `language:typescript` |
| `path:PATH` | ファイルパス | `path:src/`, `path:*.ts` |
| `path:/` | ルートディレクトリ | `path:/ filename:README` |
| `filename:NAME` | ファイル名 | `filename:config.json` |
| `extension:EXT` | 拡張子 | `extension:yml` |
| `content:TEXT` | ファイル内容のみ | `content:TODO` |
| `symbol:NAME` | シンボル（関数・クラス定義） | `symbol:useState language:tsx` |
| `is:archived` | アーカイブ済みリポジトリ | `is:archived` |
| `is:fork` | フォークリポジトリ | `is:fork` |
| `is:vendored` | vendor ディレクトリ | `NOT is:vendored` |
| `is:generated` | 自動生成ファイル | `NOT is:generated` |

## リポジトリ検索修飾子

| 修飾子 | 説明 | 例 |
|--------|------|-----|
| `stars:N` | スター数 | `stars:>1000`, `stars:100..500` |
| `forks:N` | フォーク数 | `forks:>=100` |
| `size:N` | サイズ（KB） | `size:<1000` |
| `created:DATE` | 作成日 | `created:>2024-01-01` |
| `pushed:DATE` | 最終プッシュ日 | `pushed:>2024-01-01` |
| `language:LANG` | 主要言語 | `language:rust` |
| `topic:TOPIC` | トピック | `topic:cli` |
| `license:LICENSE` | ライセンス | `license:mit` |
| `is:public` / `is:private` | 可視性 | `is:public` |
| `archived:true/false` | アーカイブ状態 | `archived:false` |
| `mirror:true/false` | ミラー | `mirror:false` |
| `template:true/false` | テンプレート | `template:true` |

## ブール演算子

| 演算子 | 説明 | 例 |
|--------|------|-----|
| `AND` / スペース | 両方含む | `label:bug label:urgent` |
| `OR` | どちらか | `label:bug OR label:enhancement` |
| `NOT` / `-` | 除外 | `NOT is:draft`, `-label:wip` |
| `()` | グループ化 | `(label:bug OR label:error) is:open` |

## 正規表現とワイルドカード

```bash
# 正規表現（スラッシュで囲む）- コード検索のみ
/auth.*token/i

# パスのグロブパターン - コード検索のみ
path:"src/**/*.ts"
path:"*.json"

# 完全一致（クォートで囲む）
"exact phrase"
```

## 実用的な検索例

```bash
# 自分がレビューをリクエストされている PR
gh pr list --search "review-requested:@me"
gh search prs "review-requested:@me is:open"

# 過去7日間に作成された未対応バグ
gh issue list --search "label:bug created:>2024-01-01"

# レビュー承認済みだが未マージの PR
gh pr list --search "review:approved"
gh search prs "review:approved is:unmerged is:open"

# 担当者なしでラベルもないオープン Issue
gh issue list --search "no:assignee no:label"

# 特定ディレクトリ内の TypeScript ファイルでエラーハンドリング
gh search code "catch" --language typescript --repo owner/repo path:src/

# 組織全体でセキュリティラベルの Issue
gh search issues "label:security is:open" --owner my-org

# マージされた自分の PR（今月）
gh search prs "author:@me is:merged merged:>2024-01-01"
```
