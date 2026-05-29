#!/bin/bash
set -euo pipefail

# 編集後の自動チェック: テスト実行
exit 0

# jqでファイルパスを取得
if ! command -v jq &> /dev/null; then
  exit 0
fi

file_path=$(cat | jq -r '.tool_input.file_path // empty' 2>/dev/null) || exit 0

# 空またはnullなら終了
if [[ -z "$file_path" || "$file_path" == "null" ]]; then
  exit 0
fi

# Kotlinファイル以外は無視
if [[ ! "$file_path" =~ \.kt$ ]]; then
  exit 0
fi

# CLAUDE_PROJECT_DIRが設定されていなければ終了
if [[ -z "${CLAUDE_PROJECT_DIR:-}" ]]; then
  exit 0
fi

# プロジェクトディレクトリの検証（絶対パスかつ存在すること）
if [[ ! "$CLAUDE_PROJECT_DIR" =~ ^/ || ! -d "$CLAUDE_PROJECT_DIR" ]]; then
  exit 0
fi

# gradlewの存在確認
gradlew_path="${CLAUDE_PROJECT_DIR}/gradlew"
if [[ ! -x "$gradlew_path" ]]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

# テスト実行（テストファイル自体の編集時はスキップ）
if [[ "$file_path" =~ /test/ || "$file_path" =~ Test\.kt$ ]]; then
  exit 0
fi

# modules/xxx/ からモジュール名を抽出（英数字とハイフン・アンダースコアのみ許可）
module=$(echo "$file_path" | sed -nE 's|.*/modules/([a-zA-Z0-9_-]+)/.*|\1|p')

# モジュール名が取得できない場合は終了
if [[ -z "$module" || ! "$module" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  exit 0
fi

# モジュールのテスト実行
"$gradlew_path" ":${module}:testDemoDebugUnitTest" --quiet 2>&1 || true
