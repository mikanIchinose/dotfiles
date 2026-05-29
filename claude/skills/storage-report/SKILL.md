---
name: storage-report
model: haiku
description: ストレージ使用量を調査しレポートを生成。「ストレージ調査」「ディスク容量」「storage report」と依頼された際に使用。
---

macOS のストレージ使用量を JSON 形式で出力し、段階的にディレクトリを掘り進んで調査できるスキル。

## 使用方法

```bash
# ホームディレクトリの概要
bash ~/dotfiles/claude/skills/storage-report/scripts/storage-report.sh

# 特定ディレクトリを掘り下げ
bash ~/dotfiles/claude/skills/storage-report/scripts/storage-report.sh ~/Library
bash ~/dotfiles/claude/skills/storage-report/scripts/storage-report.sh ~/Library/Caches
bash ~/dotfiles/claude/skills/storage-report/scripts/storage-report.sh /nix
```

## 出力形式

```json
{
  "generated_at": "2026-01-25T10:00:00+09:00",
  "tool": { "diskus_available": true },
  "disk": {
    "total_bytes": 494384795648,
    "used_bytes": 381699293184,
    "available_bytes": 112685502464,
    "used_percent": 78
  },
  "target": {
    "path": "/Users/mikan",
    "size_bytes": 123456789,
    "size_human": "117.7M"
  },
  "children": [
    {
      "name": "Library",
      "path": "/Users/mikan/Library",
      "type": "directory",
      "size_bytes": 89012345678,
      "size_human": "82.9G"
    }
  ]
}
```

## 調査フロー

1. 引数なしで実行 → ホームディレクトリの子要素を確認
2. 大きいディレクトリを引数に指定して再実行 → 中身を確認
3. 繰り返して問題箇所を特定

## 削除候補の判断基準

### 安全に削除可能

| 対象 | コマンド |
|------|----------|
| Android Studio エラーダンプ | `rm ~/java_error_in_studio.hprof` |
| Homebrew キャッシュ | `brew cleanup --prune=all` |
| Xcode DerivedData | `rm -rf ~/Library/Developer/Xcode/DerivedData/*` |
| 不要な iOS Simulator | `xcrun simctl delete unavailable` |
| Nix GC | `nix-collect-garbage` |

### 要確認（削除前にユーザーに確認）

- `~/Library/Caches/Google` - ブラウザ・Android Studio キャッシュ
- `~/fvm` - Flutter バージョン
- `~/ghq*` - リポジトリ
