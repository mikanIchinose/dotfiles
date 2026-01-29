---
name: cleanup-worktree
description: 不要なworktreeとブランチを掃除。「worktree掃除」「ブランチ整理」「cleanup worktree」と依頼された際に使用。
allowed-tools: Bash(bash ~/.claude/skills/cleanup-worktree/scripts/*.sh), Bash(gwq *), Bash(git branch *)
---

Git worktree とブランチを対話的に掃除するスキル。

## 前提条件

- `gwq` コマンドがインストールされていること
- `jq` コマンドがインストールされていること

## 手順

### 0. 依存ツールチェック

!`bash ~/.claude/skills/cleanup-worktree/scripts/check-deps.sh`

`ok: false` の場合は不足ツールをインストールするよう案内して終了。

### 1. Worktree の状況確認

!`gwq status`

出力から worktree を以下のカテゴリに分類:

| カテゴリ | 説明 | 削除推奨度 |
|---------|------|-----------|
| 古い inactive (3ヶ月以上) + 変更なし | 長期間操作なし、クリーン | 高 |
| 古い inactive (3ヶ月以上) + 変更あり | 長期間操作なし、未コミット変更あり | 要確認（作業中の可能性） |
| 中程度 inactive (1-3ヶ月) | しばらく操作なし | 中 |
| 一時 worktree (-worktree-N) | 一時的に作成されたもの | 高 |
| 変更あり (changed/staged/modified) | 未コミットの変更あり | 低（作業中の可能性大） |
| up to date | クリーンな状態 | 低 |

**重要**: `changed`/`staged`/`modified` ステータスや `N modified`/`N untracked` 表示があるworktreeは作業中の可能性が高いため、削除前に必ず確認すること。

### 2. Worktree 削除対象の確認

AskUserQuestion で削除対象を確認。選択肢例:
- 古い inactive のみ（3ヶ月以上、変更なし）
- inactive すべて（1ヶ月以上）
- 一時 worktree のみ
- 個別に選びたい

### 3. Worktree の削除

```bash
gwq remove <branch-name>
```

### 4. ブランチの状況確認

#### gone ブランチ（リモートで削除済み）

!`bash ~/.claude/skills/cleanup-worktree/scripts/gone-branches.sh`

#### worktree なしブランチ

!`bash ~/.claude/skills/cleanup-worktree/scripts/orphan-branches.sh`

### 5. ブランチ削除対象の確認

AskUserQuestion で削除対象を確認。選択肢例:
- gone のみ
- gone + 削除済 worktree のブランチ
- 全て（worktree なし含む）

### 6. ブランチの削除

```bash
# マージ済みブランチを削除（安全）
git branch -d <branch-name>

# not fully merged エラーの場合、強制削除（要ユーザー確認）
git branch -D <branch-name>
```

**注意**: worktree に関連付けられているブランチは削除不可。先に worktree を削除する。

### 7. 削除後の確認

!`gwq status`

期待通りに削除されていない場合は、手順 2〜6 を繰り返す。

## 削除時の注意事項

- **変更ありの worktree**: 削除前に変更内容を確認（作業中の可能性大）
- **not fully merged エラー**: リモートで削除済み(gone)なら強制削除(-D)可能
- **worktree に紐づくブランチ**: 先に `gwq remove` で worktree を削除

## 出力フォーマット

削除完了後、以下の形式で結果を報告:

```
## 完了

### 削除したもの

**Worktree（N個）:**
- branch-1
- branch-2

**ブランチ（N個）:**
- branch-1
- branch-2

### 現在の状態
- **Worktree**: X個 → Y個
- **ブランチ**: X個 → Y個
```
