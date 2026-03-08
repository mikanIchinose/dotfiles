#!/bin/bash
#
# GitHub GraphQL APIを使用してsub-issueを登録するスクリプト
#
# 使用方法:
#   ./scripts/add-sub-issue.sh <親issue番号> <sub-issue番号> [<sub-issue番号>...]
#
# 例:
#   ./scripts/add-sub-issue.sh 13 19 20 21
#
# 必要条件:
#   - gh CLI がインストールされていること
#   - gh auth login で認証済みであること

set -euo pipefail

# 引数チェック
if [ $# -lt 2 ]; then
    echo "<error>引数が不足しています</error>"
    echo "<usage>$0 <親issue番号> <sub-issue番号> [<sub-issue番号>...]</usage>"
    echo "<example>$0 13 19 20 21</example>"
    exit 1
fi

PARENT_ISSUE_NUMBER=$1
shift
SUB_ISSUE_NUMBERS=("$@")

# リポジトリ情報を取得
REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null)
if [ -z "$REPO" ]; then
    echo "<error>リポジトリ情報の取得に失敗しました。リポジトリ内で実行してください。</error>"
    exit 1
fi

OWNER=$(echo "$REPO" | cut -d'/' -f1)
NAME=$(echo "$REPO" | cut -d'/' -f2)

echo "<context>"
echo "  <repository>$REPO</repository>"
echo "  <parent_issue>$PARENT_ISSUE_NUMBER</parent_issue>"
echo "  <sub_issues>${SUB_ISSUE_NUMBERS[*]}</sub_issues>"
echo "</context>"

# issueのIDを取得
get_issue_id() {
    local issue_number=$1
    gh api graphql -f query="
        query {
            repository(owner: \"$OWNER\", name: \"$NAME\") {
                issue(number: $issue_number) {
                    id
                    title
                }
            }
        }
    " --jq '.data.repository.issue.id' 2>/dev/null || echo ""
}

# issueのタイトルを取得
get_issue_title() {
    local issue_number=$1
    gh api graphql -f query="
        query {
            repository(owner: \"$OWNER\", name: \"$NAME\") {
                issue(number: $issue_number) {
                    title
                }
            }
        }
    " --jq '.data.repository.issue.title' 2>/dev/null || echo ""
}

# sub-issueを追加
add_sub_issue() {
    local parent_id=$1
    local child_id=$2
    local child_number=$3

    result=$(gh api graphql \
        -H "GraphQL-Features: sub_issues" \
        -f parentId="$parent_id" \
        -f childId="$child_id" \
        -f query='
            mutation($parentId: ID!, $childId: ID!) {
                addSubIssue(input: { issueId: $parentId, subIssueId: $childId }) {
                    issue { number title }
                    subIssue { number title }
                }
            }
        ' 2>&1)

    if echo "$result" | grep -q '"errors"'; then
        error_msg=$(echo "$result" | jq -r '.errors[0].message // "Unknown error"' 2>/dev/null || echo "$result")
        echo "<sub_issue number=\"$child_number\" status=\"failed\">"
        echo "  <error>$error_msg</error>"
        echo "</sub_issue>"
        return 1
    else
        sub_title=$(echo "$result" | jq -r '.data.addSubIssue.subIssue.title')
        echo "<sub_issue number=\"$child_number\" status=\"success\">"
        echo "  <title>$sub_title</title>"
        echo "</sub_issue>"
        return 0
    fi
}

# 親issueのID取得
PARENT_ID=$(get_issue_id "$PARENT_ISSUE_NUMBER")
if [ -z "$PARENT_ID" ]; then
    echo "<error>親Issue #$PARENT_ISSUE_NUMBER が見つかりません</error>"
    exit 1
fi

PARENT_TITLE=$(get_issue_title "$PARENT_ISSUE_NUMBER")
echo "<parent_issue number=\"$PARENT_ISSUE_NUMBER\">"
echo "  <title>$PARENT_TITLE</title>"
echo "  <id>$PARENT_ID</id>"
echo "</parent_issue>"

# 各sub-issueを登録
echo "<results>"
success_count=0
fail_count=0

for sub_number in "${SUB_ISSUE_NUMBERS[@]}"; do
    sub_id=$(get_issue_id "$sub_number")
    if [ -z "$sub_id" ]; then
        echo "<sub_issue number=\"$sub_number\" status=\"not_found\">"
        echo "  <error>Issueが見つかりません</error>"
        echo "</sub_issue>"
        ((fail_count++))
        continue
    fi

    if add_sub_issue "$PARENT_ID" "$sub_id" "$sub_number"; then
        ((success_count++))
    else
        ((fail_count++))
    fi
done

echo "</results>"

echo "<summary>"
echo "  <success_count>$success_count</success_count>"
echo "  <fail_count>$fail_count</fail_count>"
echo "</summary>"

if [ $fail_count -gt 0 ]; then
    exit 1
fi
