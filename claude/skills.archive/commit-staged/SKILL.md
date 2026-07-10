---
name: commit-staged
model: haiku
description: ステージ済みファイルをgit commitする。「コミット」「commit」と依頼された際に使用。
disable-model-invocation: true
---

## commit context

- status: !`git status`
- diff: !`git diff --cached`
- previous commit messages: !`git log --oneline -10`

## Task

git commit based on staged files
