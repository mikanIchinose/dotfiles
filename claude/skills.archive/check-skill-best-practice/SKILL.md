---
name: check-skill-best-practice
description: skillをレビュー
argument-hint: [skill]
context: fork
---

$ARGUMENTS がskillのベストプラクティスに沿っているかをレビュー

## 重要: ツール参照のレビュー時の注意

スキル内でツール名（例: `AskUserQuestion`, `TaskOutput` など）が参照されている場合、そのツールが「存在しない」「不明」と断定する前に、**必ず WebSearch で Claude Code の最新ドキュメントを確認**すること。

Claude Code は頻繁に更新され、新しいツールが追加されるため、自身の知識だけで判断しない。

## Example

```
/check-skill-best-practice test-guideline
```

## Best Practice

See [best-practice.md](best-practice.md) for the complete best practice guide.
