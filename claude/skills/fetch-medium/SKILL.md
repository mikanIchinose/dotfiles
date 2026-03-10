---
name: fetch-medium
model: haiku
description: Medium.com の記事を取得する。WebFetch では 404 になるため Claude in Chrome MCP を利用する。trigger「medium」「medium.com」「https://medium.com/...」
---

Medium.com の記事コンテンツを Claude in Chrome MCP 経由で取得するスキル。

## 背景

Medium.com は自動アクセス（bot）をブロックしているため、WebFetch では 404/403 になる。
Claude in Chrome 拡張機能を使い、実際のブラウザ経由でページを読み込むことで回避する。

## 前提条件

- Claude in Chrome 拡張機能がインストール済みであること
- Chrome が起動中であること

## 手順

### 1. ToolSearch でツールをロード

Claude in Chrome の MCP ツールは deferred tool なので、使用前に必ず ToolSearch でロードする:

```
ToolSearch: select:mcp__claude-in-chrome__tabs_context_mcp,mcp__claude-in-chrome__tabs_create_mcp,mcp__claude-in-chrome__navigate,mcp__claude-in-chrome__get_page_text
```

### 2. タブの準備

1. `tabs_context_mcp` で現在のタブ状況を取得する（`createIfEmpty: true`）
2. `tabs_create_mcp` で新しいタブを作成する（既存タブの再利用は避ける）

### 3. 記事の取得

1. `navigate` で ARGUMENTS の URL に遷移する
2. `get_page_text` で記事本文を取得する

`get_page_text` は `<article>` 要素を優先的に抽出するため、Medium 記事の本文を自動的に取得できる。コードブロックも含めてテキストとして返される。

### 4. コードブロックの整形が必要な場合

`get_page_text` でコードブロックのフォーマットが不十分な場合は、`javascript_tool` で Markdown 風に取得する:

```
ToolSearch: select:mcp__claude-in-chrome__javascript_tool
```

```javascript
const article = document.querySelector('article');
if (!article) return 'No article found';
const blocks = article.querySelectorAll('p, h1, h2, h3, h4, pre, li, blockquote');
let result = '';
for (const el of blocks) {
  if (el.tagName === 'PRE') {
    result += '\n```\n' + el.innerText + '\n```\n\n';
  } else if (el.tagName.startsWith('H')) {
    const level = '#'.repeat(parseInt(el.tagName[1]));
    result += level + ' ' + el.innerText + '\n\n';
  } else if (el.tagName === 'LI') {
    result += '- ' + el.innerText + '\n';
  } else if (el.tagName === 'BLOCKQUOTE') {
    result += '> ' + el.innerText + '\n\n';
  } else {
    result += el.innerText + '\n\n';
  }
}
return result;
```

## 注意事項

- **WebFetch は使用しない**（必ず失敗する）
- 基本的には `get_page_text` だけで十分。JavaScript による手動抽出はフォールバック
- Medium 以外のサイトはまず WebFetch を試み、失敗した場合にのみこのスキルを参照する
