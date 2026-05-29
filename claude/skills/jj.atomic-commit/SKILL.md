---
name: jj.atomic-commit
description: jj管理下の変更を論理単位に分割してアトミックにコミットする。jjリポジトリで「まとめてコミット」「atomic commit」「変更を整理してコミット」と依頼された際に使用。
allowed-tools: Bash("jj status:*"), Bash("jj diff:*"), Bash("jj log:*"), Bash("jj split:*"), Bash("jj describe:*")
---

## context

- status: `jj status`
- diff stat: `jj diff --stat`
- log: `jj log --limit 10`

## Task

jjのワーキングコピー（@）の変更を論理的な単位に分割し、`jj split` でアトミックなコミットとして作成する。

### ワークフロー

1. **変更の全体像を把握**: `jj status` と `jj diff` から全変更を確認
2. **論理単位に分類**: 変更をスコープ（機能/レイヤー）ごとにグループ化
3. **分割案を提示し、そのままコミット実行**: 承認を求めず一気に進める

### 分割の基準

- CLAUDE.md のコミットメッセージ規約に従う（Conventional Commits形式）
- 1コミット = 1スコープ = 1つの論理的変更
- 複数スコープにまたがるファイル変更がある場合はコミットを分ける
- 関連する変更（例: リソースファイル群、サブクラス群）は同じコミットにまとめる
- 依存関係を考慮した順序で分割する（基底クラス → サブクラス → 統合コード）

### 提示フォーマット

```
## コミット分割案

### 1. `<type>: <description>`
- path/to/file1
- path/to/file2

### 2. `<type>: <description>`
- path/to/file3

続けてコミットします。
```

### jj split の実行方法

`jj split` をファイルパス指定で順次実行する。最後の変更は `jj describe` でメッセージを設定する。

```bash
# 1番目〜N-1番目のコミット: jj split でファイルを指定して分割
jj split -m "<commit message>" -- <file1> <file2> ...

# 最後のコミット: 残った変更に describe でメッセージ設定
jj describe -m "<commit message>"
```

