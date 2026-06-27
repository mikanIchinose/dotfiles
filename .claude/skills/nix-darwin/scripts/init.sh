#!/usr/bin/env bash
# nix-darwin スキルのセットアップ。
# flake.lock にピンされた rev に合わせて nix-darwin / nix-homebrew のソースを
# /tmp に用意する。これにより「読むオプション集合」が実機（インストール済みの
# システム）と一致し、誤ったオプション提案を防ぐ。
#
# Usage: scripts/init.sh [flake-dir]
#   flake-dir 省略時はカレントの git リポジトリルートを使う。

set -euo pipefail

FLAKE_DIR="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
LOCK="$FLAKE_DIR/flake.lock"

if [[ ! -f "$LOCK" ]]; then
  echo "error: $LOCK が見つかりません。nix flake のルートで実行してください。" >&2
  exit 1
fi

# flake.lock から input のロック情報（owner/repo/rev）を取り出して /tmp へ用意する。
# input が無い場合はスキップ。既に同じ rev が展開済みなら何もしない。
prepare_source() {
  local input="$1" dest="/tmp/$2"

  # root.inputs はエイリアス名 → ノード名の対応。無ければ input 名をそのまま使う。
  local node
  node="$(jq -r --arg i "$input" '.nodes.root.inputs[$i] // $i' "$LOCK")"

  if [[ "$(jq -r --arg n "$node" '.nodes[$n] // "null"' "$LOCK")" == "null" ]]; then
    echo "skip: input '$input' は flake.lock に存在しません" >&2
    return 0
  fi

  local owner repo rev
  owner="$(jq -r --arg n "$node" '.nodes[$n].locked.owner' "$LOCK")"
  repo="$(jq -r --arg n "$node" '.nodes[$n].locked.repo' "$LOCK")"
  rev="$(jq -r --arg n "$node" '.nodes[$n].locked.rev' "$LOCK")"

  if [[ -d "$dest/.git" && "$(git -C "$dest" rev-parse HEAD 2>/dev/null)" == "$rev" ]]; then
    echo "ok: $dest は既に $rev (最新のピン版)"
    return 0
  fi

  echo "==> $owner/$repo @ ${rev:0:12} を $dest に用意"
  rm -rf "$dest"
  git init -q "$dest"
  git -C "$dest" remote add origin "https://github.com/$owner/$repo.git"
  # GitHub は commit SHA 直接 fetch を許可しているため depth 1 で取得できる。
  git -C "$dest" fetch -q --depth 1 origin "$rev"
  git -C "$dest" checkout -q FETCH_HEAD
  echo "    done"
}

prepare_source "nix-darwin" "nix-darwin"
prepare_source "nix-homebrew" "nix-homebrew"

echo
echo "ソース準備完了:"
echo "  /tmp/nix-darwin   … modules/ (オプション定義+実装), tests/ (使用例)"
echo "  /tmp/nix-homebrew … homebrew の tap trust/bootstrap 層"
