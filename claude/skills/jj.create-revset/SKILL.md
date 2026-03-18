---
name: jj.create-revset
description: 'jj revset 式を構築する。jj log/rebase/diff 等で -r に渡す revset を組み立てたいとき、revset の書き方を知りたいとき、コミットの絞り込み条件を相談されたときに使用。trigger「revset」「-r で指定」「コミットを絞り込み」「jj log で特定の」'
---

# jj revset クエリ構築スキル

ユーザーの要求を分析し、必要なリファレンスを参照して revset 式を組み立てる。

## ディシジョンテーブル: 参照すべきリファレンス

| ユーザーの要求 | 参照先 |
|---------------|--------|
| 特定のコミットを指定したい（親、子、@） | [symbols.md](references/symbols.md) |
| 範囲や集合演算を使いたい（`..`, `::`, `&`, `~`） | [symbols.md](references/symbols.md) |
| 条件で絞り込みたい（著者、日付、ファイル、説明文） | [functions.md](references/functions.md) |
| コミット集合を加工したい（heads, roots, latest） | [functions.md](references/functions.md) |
| ブックマーク・タグ・リモートを参照したい | [functions.md](references/functions.md) |
| 文字列マッチの書き方を知りたい（glob, regex, exact） | [patterns.md](references/patterns.md) |
| 日付の指定方法を知りたい（after, before, 相対日付） | [patterns.md](references/patterns.md) |
| 実用的な使用例がほしい / やりたいことから逆引きしたい | [recipes.md](references/recipes.md) |

### 複数リファレンスが必要なケース

| ユーザーの要求例 | 参照先 |
|-----------------|--------|
| 「trunk から @ までの自分のコミット」 | symbols.md → functions.md |
| 「最近1週間で特定ファイルを変更したコミット」 | functions.md → patterns.md |
| 「リモートにない空でないコミットを最新5件」 | symbols.md → functions.md |

## 構築手順

1. ディシジョンテーブルに従い、必要なリファレンスを特定する
2. リファレンスを参照して式の部品を集める
3. 部品を演算子（`&`, `|`, `~`）で合成する
4. シェルでの引用に注意（`|` を含む式はクォート必須）
