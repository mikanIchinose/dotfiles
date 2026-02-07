---
allowed-tools: Bash(gh label list*)
---

## Context
- diff: !`git log main..HEAD --oneline`
- status: !`git diff main..HEAD --stat`
- labels: !`gh label list --limit 50`

## Task
create draft pr

## Rules
- use PR template if exist
- ask user to select label
