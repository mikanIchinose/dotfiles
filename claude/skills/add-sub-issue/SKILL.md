---
name: add-sub-issue
description: GitHub issueにsub-issueを登録。「sub-issue登録」「サブイシュー追加」「子issue追加」と依頼された際に使用。
---

# Sub-issue 登録スキル

GitHub GraphQL APIを使用して、親issueにsub-issueを登録する。

## 前提条件

- gh CLI がインストールされ、認証済みであること
- 対象のissueが既に作成されていること

## 使用方法

### 1. スクリプトの実行

```bash
./.claude/skills/add-sub-issue/scripts/add-sub-issue.sh <親issue番号> <sub-issue番号> [<sub-issue番号>...]
```

### 2. 実行例

```bash
# 単一のsub-issueを登録
./.claude/skills/add-sub-issue/scripts/add-sub-issue.sh 13 19

# 複数のsub-issueを一括登録
./.claude/skills/add-sub-issue/scripts/add-sub-issue.sh 13 19 20 21 22 23
```

## 出力形式

スクリプトはXMLタグ形式で結果を出力する。

### 成功時

```xml
<context>
  <repository>owner/repo</repository>
  <parent_issue>13</parent_issue>
  <sub_issues>19 20 21</sub_issues>
</context>
<parent_issue number="13">
  <title>親Issueのタイトル</title>
  <id>I_xxx</id>
</parent_issue>
<results>
<sub_issue number="19" status="success">
  <title>Sub-issueのタイトル</title>
</sub_issue>
</results>
<summary>
  <success_count>1</success_count>
  <fail_count>0</fail_count>
</summary>
```

### 失敗時

```xml
<sub_issue number="19" status="failed">
  <error>エラーメッセージ</error>
</sub_issue>
```

## 注意事項

- 同じsub-issueを重複して登録しようとするとエラーになる
- sub-issue機能はGitHub Public Preview機能のため、`GraphQL-Features: sub_issues`ヘッダーが必要
- issueが見つからない場合は `status="not_found"` で報告される

## 手動でのGraphQL API使用

スクリプトを使わず直接APIを叩く場合:

```bash
# 1. Issue IDを取得
gh api graphql -f query='
query {
  repository(owner: "OWNER", name: "REPO") {
    issue(number: ISSUE_NUMBER) { id }
  }
}'

# 2. sub-issueを登録
gh api graphql \
  -H "GraphQL-Features: sub_issues" \
  -f parentId="PARENT_ID" \
  -f childId="CHILD_ID" \
  -f query='
mutation($parentId: ID!, $childId: ID!) {
  addSubIssue(input: { issueId: $parentId, subIssueId: $childId }) {
    issue { number title }
    subIssue { number title }
  }
}'
```
