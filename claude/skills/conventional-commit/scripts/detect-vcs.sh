#!/usr/bin/env bash
# Detect VCS type (jj or git) for the current repository
# Usage: detect-vcs.sh [directory]
# Output: "jj" or "git"
# Exit code: 0 on success, 1 if no VCS found

set -euo pipefail

dir="${1:-.}"

# Find repository root by walking up
find_repo_root() {
  local d
  d="$(cd "$dir" && pwd)"
  while [ "$d" != "/" ]; do
    if [ -d "$d/.jj" ] || [ -d "$d/.git" ]; then
      echo "$d"
      return 0
    fi
    d="$(dirname "$d")"
  done
  return 1
}

root="$(find_repo_root)" || { echo "error: no VCS repository found" >&2; exit 1; }

if [ -d "$root/.jj" ]; then
  echo "jj"
else
  echo "git"
fi
