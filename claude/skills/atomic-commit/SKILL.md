---
name: atomic-commit
description: 未コミットの変更を論理単位に分割してアトミックにコミットする。「まとめてコミット」「atomic commit」「変更を整理してコミット」と依頼された際に使用。
---

## context

- status: !`git status`
- diff: !`git diff`
- diff staged: !`git diff --cached`
- previous commit messages: !`git log --oneline -10`

## Task

未コミットの変更（unstaged + staged）を論理的な単位に分割し、それぞれをアトミックなコミットとして作成する。

### ワークフロー

1. **変更の全体像を把握**: status と diff から全変更を確認
2. **論理単位に分類**: 変更をスコープ（ツール/機能）ごとにグループ化
3. **ユーザーに分割案を提示**: どのファイルをどのコミットにまとめるか一覧で提示し、承認を得る
4. **順番にコミット**: 承認後、グループごとに `git add <files>` → `git commit`

### 分割の基準

- CLAUDE.md のコミットメッセージ規約に従う（スコープ単位）
- 1コミット = 1スコープ = 1つの論理的変更
- 複数スコープにまたがるファイル変更がある場合はコミットを分ける
- 関連する変更（例: default.nix と update.sh）は同じコミットにまとめる
- untracked ファイルも対象に含める

### 提示フォーマット

```
## コミット分割案

### 1. `<scope>: <description>`
- path/to/file1
- path/to/file2

### 2. `<scope>: <description>`
- path/to/file3

承認後、順番にコミットします。
```
