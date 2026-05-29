# gh pr - 高度な PR 操作

**検索クエリ:** [search-query.md](./search-query.md)

## 一覧・検索

```bash
# PR 一覧（高度なフィルタリング）
gh pr list --search "review:required draft:false"
gh pr list --json number,title,reviewDecision

# 状態で絞り込み
gh pr list --state all
gh pr list --state merged
```

## 差分・チェック

```bash
# 差分の表示
gh pr diff {number}
gh pr diff {number} --patch       # patch 形式
gh pr diff {number} --name-only   # ファイル名のみ

# チェック（CI）の待機
gh pr checks {number} --watch --fail-fast
```

## チェックアウト

```bash
# PR をローカルにチェックアウト
gh pr checkout {number}
gh pr checkout {url}
```

## 編集

```bash
# レビュアー・アサイン
gh pr edit {number} --add-reviewer user1,user2
gh pr edit {number} --add-assignee @me

# ラベル操作
gh pr edit {number} --add-label "bug,urgent"
gh pr edit {number} --remove-label "wip"

# 本文の更新（Issue リンクは本文内のキーワードで行う）
gh pr edit {number} --body "Fixes #123"
```

## マージ

```bash
# マージ後ブランチ削除
gh pr merge {number} --squash --delete-branch

# マージ方法
gh pr merge {number} --merge      # マージコミット
gh pr merge {number} --squash     # スカッシュ
gh pr merge {number} --rebase     # リベース
```

## Draft PR

```bash
# Draft PR 作成
gh pr create --draft

# Draft を Ready に変換
gh pr ready {number}
```
