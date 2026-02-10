---
name: create-draft-pr
description: Draft PRを作成する。「PR作成」「draft PR」「create draft pr」と依頼された際に使用。
allowed-tools: Bash(gh label list*), Bash(gh issue view*), Bash(gh repo view*), Bash(git log*), Bash(git diff*), Bash(git rev-parse*)
---

## Context
- default branch: !`gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'`

## Workflow

1. **Gather context** (parallel):
   - commit: `git log <default-branch>..HEAD --oneline`
   - diff: `git diff <default-branch>..HEAD --stat`
   - labels: !`gh label list --limit 50`
   - Check for PR template (`.github/PULL_REQUEST_TEMPLATE/default.md` or `.github/PULL_REQUEST_TEMPLATE.md`)
2. **Determine PR title**:
   - Extract issue number from branch name (e.g., `feature/9794-xxx` → `#9794`)
   - If found, fetch title with `gh issue view <number> --json title --jq '.title'`
   - If not found, derive from commit messages
3. **Ask user to select labels** with AskUserQuestion
4. **Create draft PR**: `gh pr create --draft --base <base>`
   - Use PR template for body structure if it exists
