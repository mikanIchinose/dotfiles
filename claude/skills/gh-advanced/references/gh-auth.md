# gh auth - 認証関連

## トークン

```bash
# トークンの表示
gh auth token

# 特定ユーザーのトークン取得
gh auth token --user username
```

## 認証状態

```bash
# 認証状態の確認
gh auth status

# ログイン
gh auth login
gh auth login --web  # ブラウザで認証
```

## スコープ追加

```bash
# 追加スコープでの再認証
gh auth refresh -s admin:org
gh auth refresh -s project        # Projects 操作に必要
gh auth refresh -s read:project   # Projects 読み取りのみ
gh auth refresh -s gist           # Gist 操作
```

## 複数アカウント管理

```bash
# アカウント切り替え
gh auth switch

# 特定ユーザーでログアウト
gh auth logout --user username
```

## グローバルオプション

多くのコマンドで使用可能な共通オプション。

```bash
# JSON 出力
gh pr list --json number,title,author

# jq でフィルタリング
gh pr list --json number,title --jq '.[] | "\(.number): \(.title)"'

# テンプレート出力
gh pr list --template '{{range .}}{{.number}}: {{.title}}{{"\n"}}{{end}}'

# リポジトリ指定（カレントディレクトリ以外）
gh pr list --repo owner/repo

# ブラウザで開く
gh pr view {number} --web
gh issue view {number} --web
gh repo view --web
```
