# gh api - 直接 API アクセス

REST API や GraphQL を直接叩ける強力なコマンド。

## 基本的な使い方

```bash
# REST API
gh api repos/{owner}/{repo}/pulls
gh api repos/{owner}/{repo}/issues --jq '.[].title'

# ページネーション（全件取得）
gh api repos/{owner}/{repo}/issues --paginate

# ページネーション + 結果集約（--slurp で配列をマージ）
gh api repos/{owner}/{repo}/issues --paginate --slurp --jq 'length'

# POST リクエスト
gh api repos/{owner}/{repo}/issues -f title="Bug" -f body="Description"

# HTTP メソッド指定
gh api -X DELETE repos/{owner}/{repo}/issues/{number}/labels/{label}
```

## GraphQL

```bash
gh api graphql -f query='
  query {
    viewer {
      login
      repositories(first: 10) {
        nodes { name }
      }
    }
  }
'
```

## 出力オプション

```bash
# JSON 出力のフィルタリング（jq 構文）
gh api repos/{owner}/{repo}/pulls --jq '.[] | {number, title, user: .user.login}'

# レスポンスヘッダーを含める
gh api repos/{owner}/{repo} --include

# サイレントモード（出力なし、ステータスコードのみ）
gh api repos/{owner}/{repo} --silent
```

## リクエストオプション

```bash
# カスタムヘッダー
gh api repos/{owner}/{repo} -H "Accept: application/vnd.github.v3+json"

# プレビュー機能の有効化
gh api repos/{owner}/{repo}/environments --preview mercy

# キャッシュ（同一リクエストをキャッシュ）
gh api repos/{owner}/{repo} --cache 1h
```

## 主要オプション一覧

| オプション | 説明 |
|-----------|------|
| `-X, --method` | HTTP メソッド |
| `-f, --raw-field` | フィールド（文字列） |
| `-F, --field` | フィールド（型推論あり: true/false/null/整数、@でファイル読み込み） |
| `--jq` | jq でフィルタリング |
| `--paginate` | 全ページ取得 |
| `--slurp` | ページネーション結果を配列にマージ |
| `--include` | レスポンスヘッダーを含める |
| `--silent` | 出力なし |
| `-H, --header` | カスタムヘッダー |
| `--preview` | プレビュー機能有効化 |
| `--cache` | キャッシュ時間 |
