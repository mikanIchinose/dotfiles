# gh issue - 高度な Issue 操作

**検索クエリ:** [search-query.md](./search-query.md)

## 一覧・検索

```bash
# Issue 一覧（高度なフィルタリング）
gh issue list --search "is:open sort:updated-desc"
gh issue list --json number,title,labels

# 状態で絞り込み
gh issue list --state all
gh issue list --state closed
```

## 作成

```bash
# テンプレートを使用して作成
gh issue create --template bug_report.md

# ラベル・担当者付きで作成
gh issue create --label bug --assignee @me
```

## 編集・管理

```bash
# Issue の転送
gh issue transfer {number} owner/another-repo

# ピン留め
gh issue pin {number}
gh issue unpin {number}
```

## クローズ

```bash
# クローズ（理由付き）
gh issue close {number} --reason "not planned"
gh issue close {number} --reason completed

# コメント付きでクローズ
gh issue close {number} --comment "Duplicate of #456"
```
