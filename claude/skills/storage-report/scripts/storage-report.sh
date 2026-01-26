#!/bin/bash
# storage-report.sh - ストレージ使用量をJSON形式で出力
# 段階的にディレクトリを掘り進んでいける設計
#
# Usage:
#   storage-report.sh [directory]
#
# Examples:
#   storage-report.sh           # ホームディレクトリの概要
#   storage-report.sh ~/Library # ~/Library の中身を表示
#   storage-report.sh /nix      # /nix の中身を表示

set -uo pipefail

TARGET_DIR="${1:-$HOME}"
# 絶対パスに正規化
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
    echo "Error: Cannot access directory: $1" >&2
    exit 1
}

# diskus 検出
HAS_DISKUS=$(command -v diskus >/dev/null 2>&1 && echo 1 || echo 0)

# JSON文字列のエスケープ
json_escape() {
    local str="$1"
    str="${str//\\/\\\\}"   # バックスラッシュ
    str="${str//\"/\\\"}"   # ダブルクォート
    str="${str//$'\n'/\\n}" # 改行
    str="${str//$'\t'/\\t}" # タブ
    echo "$str"
}

# バイト数を人間が読みやすい形式に変換
human_readable() {
    local bytes=$1
    if (( bytes >= 1073741824 )); then
        printf "%.1fG" "$(echo "scale=1; $bytes / 1073741824" | bc)"
    elif (( bytes >= 1048576 )); then
        printf "%.1fM" "$(echo "scale=1; $bytes / 1048576" | bc)"
    elif (( bytes >= 1024 )); then
        printf "%.1fK" "$(echo "scale=1; $bytes / 1024" | bc)"
    else
        printf "%dB" "$bytes"
    fi
}

# ディレクトリのサイズをバイト単位で取得
get_size_bytes() {
    local target="$1"
    local size=""
    if [[ "$HAS_DISKUS" == "1" ]] && [[ -e "$target" ]]; then
        size=$(diskus -b "$target" 2>/dev/null) || size=""
    fi
    if [[ -z "$size" ]]; then
        size=$(du -sk "$target" 2>/dev/null | awk '{print $1 * 1024}')
    fi
    # サイズが取得できなかった場合は 0 を返す
    echo "${size:-0}"
}

# ディスク情報を取得
get_disk_info() {
    df -k / | tail -1 | awk '{
        total = $2 * 1024
        used = $3 * 1024
        avail = $4 * 1024
        pct = $5
        gsub(/%/, "", pct)
        printf "{\"total_bytes\":%s,\"used_bytes\":%s,\"available_bytes\":%s,\"used_percent\":%s}", total, used, avail, pct
    }'
}

# ディレクトリ内の項目をJSON配列として出力
list_directory_json() {
    local dir="$1"
    local first=true

    echo "["

    # ファイルとディレクトリを取得してサイズ順にソート
    while IFS= read -r line; do
        local size_bytes=$(echo "$line" | cut -f1)
        local path=$(echo "$line" | cut -f2-)
        local name=$(basename "$path")
        local type="file"
        [[ -d "$path" ]] && type="directory"

        if [[ "$first" == "true" ]]; then
            first=false
        else
            echo ","
        fi

        local size_human=$(human_readable "$size_bytes")
        local name_escaped=$(json_escape "$name")
        local path_escaped=$(json_escape "$path")

        printf '    {"name":"%s","path":"%s","type":"%s","size_bytes":%s,"size_human":"%s"}' \
            "$name_escaped" "$path_escaped" "$type" "$size_bytes" "$size_human"

    done < <(
        # 隠しファイル・ディレクトリも含める
        for item in "$dir"/* "$dir"/.*; do
            [[ -e "$item" ]] || continue
            # . と .. はスキップ
            base=$(basename "$item")
            [[ "$base" == "." || "$base" == ".." ]] && continue
            size=""
            if [[ "$HAS_DISKUS" == "1" ]]; then
                size=$(diskus -b "$item" 2>/dev/null) || size=""
            fi
            if [[ -z "$size" ]]; then
                size=$(du -sk "$item" 2>/dev/null | awk '{print $1 * 1024}')
            fi
            size="${size:-0}"
            printf "%s\t%s\n" "$size" "$item"
        done | sort -t$'\t' -k1 -rn
    )

    echo ""
    echo "  ]"
}

# メイン出力
target_size=$(get_size_bytes "$TARGET_DIR")
target_size_human=$(human_readable "$target_size")
target_dir_escaped=$(json_escape "$TARGET_DIR")

cat << EOF
{
  "generated_at": "$(date -Iseconds)",
  "tool": {
    "diskus_available": $([[ "$HAS_DISKUS" == "1" ]] && echo "true" || echo "false")
  },
  "disk": $(get_disk_info),
  "target": {
    "path": "$target_dir_escaped",
    "size_bytes": $target_size,
    "size_human": "$target_size_human"
  },
  "children": $(list_directory_json "$TARGET_DIR")
}
EOF
