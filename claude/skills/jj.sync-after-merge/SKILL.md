---
name: jj.sync-after-merge
description: jj管理下で複数ブランチがリモートでマージ（rebase & merge含む）された後、ローカルスタックをtrunkに同期する。
allowed-tools: Bash("jj *"), Bash("git merge-base:*"), Bash("git log:*")
---

## Task

リモートで複数ブランチがマージされた（rebase & merge 含む）後、ローカルのスタックを新しい trunk に同期する。

マージの度にリベースが発生している前提で、**元のローカルコミットが残ったまま**になっている状態を解消する。

## 前提となる状況

- `feature/A`, `feature/B`, ... が順次マージされた（A → B → C の順）
- 各マージ時に後続のPRがリベースされる運用（GitHub「Rebase and merge」または同等）
- ローカルのスタックは `trunk → A → B → C → D → ... → @` の形でチェーンしている
- A, B, C, ... がマージされた後、D以降が未マージとして残っている

## ワークフロー

### 1. 最新を取得
```bash
jj git fetch
```

出力で `[deleted] untracked` と表示されるブックマークが、マージ済み候補。

### 2. 現状把握

```bash
# trunk の位置を確認（develop@origin など）
jj log -r 'trunk()'

# スタック全体を確認（マージ済みコミットは `@git` suffix で表示される）
jj log -r 'trunk()..@' --no-graph

# 削除済みブックマーク一覧
jj bookmark list | grep deleted
```

- `@git` suffix が付いたコミットがマージ済み（ブックマーク削除済み）
- 最後のマージ済みコミットの **直上** にある未マージコミットを特定する

### 3. 未マージスタックを新 trunk にリベース

最後のマージ済みの **次のコミット（未マージの先頭）** の change-id を特定し、`-s` に渡す。

```bash
jj rebase -s <first-unmerged-change-id> -d <trunk-name>@origin
```

例: `jj rebase -s nzkppmyo -d develop@origin`

これで未マージ分のみが新しい trunk の上に再配置される。

### 4. ブックマーク削除を Git に反映

```bash
jj git export
```

`@git` 参照が消え、マージ済みコミットが abandon 可能になる（一部を除く → 次ステップ）。

### 5. 孤立したマージ前コミットを abandon

マージ前のローカルコミットには2種類ある:

| ケース | commit hash | trunk内 | 扱い |
|---|---|---|---|
| rebase されずマージ | ローカルと同一 | YES | immutable → 放置（自動で hidden になる） |
| rebase されてマージ | ローカルと異なる | NO | 孤立 → `jj abandon` |

判定方法:
```bash
git merge-base --is-ancestor <local-hash> <trunk-hash> && echo "in trunk (immutable)" || echo "orphaned"
```

孤立したものだけを abandon:
```bash
jj abandon <change-id> [<change-id> ...]
```

⚠️ **一括 abandon で "immutable" エラーが出る場合**:
連鎖関係（親子）にあるコミットを一括指定すると、trunk内のコミットを経由して immutable 扱いになることがある。1つずつ順に abandon するか、trunk内でないものだけを指定する。

### 6. ローカルの trunk ブックマークを同期

```bash
jj bookmark set <trunk-name> -r <trunk-name>@origin
jj git export
```

例: `jj bookmark set develop -r develop@origin`

### 7. 最終確認

```bash
jj log -r 'trunk() | @' 
jj log -r 'trunk()..@' --limit 10
```

スタックが新 trunk の上に正しく載っていることを確認。コンフリクトが発生していれば解消する。

## 注意点

- `jj git fetch` は安全なので先に実行してよいが、`rebase` / `abandon` は状態を変更するので、プランを示して確認を取る
- コンフリクトが発生した場合は `jj resolve` で個別対応
- `op log` で巻き戻しが可能（`jj op undo` / `jj op restore`）
