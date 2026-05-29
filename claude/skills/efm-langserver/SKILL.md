---
name: efm-langserver
description: efm-langserver に lint/format ツールを追加・設定する。「efm-langserver に追加」「efm に設定」「linter を追加」「formatter を追加」「efm-langserver」と依頼された際に使用。CLI の lint/format ツールを LSP 経由でエディタに接続したい場合にも使用する。
---

# efm-langserver 設定スキル

efm-langserver は汎用の Language Server で、既存の CLI lint/format ツールを LSP プロトコル経由でエディタに接続するアダプター。

## 設定ファイル

- パス: `config/efm-langserver/config.yaml`
- home-manager で `~/.config/efm-langserver/config.yaml` に symlink される

## config.yaml の構造

```yaml
version: 2
tools:
  # <filetype>-<toolname> の命名規則でアンカー付きで定義
  <filetype>-<toolname>: &<filetype>-<toolname>
    lint-command: 'command args'
    lint-stdin: true
    lint-formats:
      - '<error-format-pattern>'

  <filetype>-<toolname>: &<filetype>-<toolname>
    format-command: 'command args'
    format-stdin: true

languages:
  <filetype>:
    - <<: *<filetype>-<toolname>
    - <<: *<filetype>-<toolname>
```

### 主要な設定キー

| キー | 用途 |
|------|------|
| `lint-command` | lint 実行コマンド |
| `lint-stdin` | stdin でファイル内容を受け取るか |
| `lint-formats` | 出力パースパターン（Vim の errorformat 形式） |
| `format-command` | フォーマット実行コマンド |
| `format-stdin` | stdin でファイル内容を受け取るか |

## ツール追加の手順

1. **ツールの出力フォーマットを調査する**
   - `<tool> --help` でオプションを確認
   - 実際にコマンドを実行して出力を確認（サンプル入力を使う）
   - gcc 互換フォーマット (`-f gcc` 等) があれば優先的に使う（パースしやすい）

2. **lint-formats パターンを書く**
   - ツールの実際の出力に合わせて errorformat パターンを作成
   - パターンの書き方は `references/error-format.md` を参照

3. **config.yaml に追記する**
   - `tools:` セクションにアンカー付きでツール定義を追加
   - `languages:` セクションに filetype とツール参照を追加

4. **動作確認**
   - サンプル入力で `lint-command` を手動実行し、出力が `lint-formats` でパースできることを確認

## 例: shellcheck の追加

```yaml
tools:
  sh-shellcheck: &sh-shellcheck
    lint-command: 'shellcheck -f gcc -x -'
    lint-stdin: true
    lint-formats:
      - '%f:%l:%c: %t%*[^:]: %m'

languages:
  sh:
    - <<: *sh-shellcheck
```

検証:
```sh
$ echo 'echo $foo' | shellcheck -f gcc -x -
-:1:6: warning: Double quote to prevent globbing and word splitting. [SC2086]
```

出力 `-:1:6: warning: ...` が `%f:%l:%c: %t%*[^:]: %m` でパースされる。
