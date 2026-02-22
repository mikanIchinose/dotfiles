---
name: fetch-medium
model: haiku
description: Medium.com の記事を取得する。WebFetch では 404 になるため Chrome DevTools MCP を利用する。trigger「medium」「medium.com」「https://medium.com/...」
---

Medium.com の記事コンテンツを Chrome DevTools MCP 経由で取得するスキル。

## 背景

Medium.com は自動アクセス（bot）をブロックしているため、WebFetch では 404/403 になる。
認証済み Chrome ブラウザを Chrome DevTools MCP で操作することで回避する。

## 前提条件

- Chrome DevTools MCP が登録済みであること
- デバッグ用 Chrome が起動中であること（`chrome:debug`）
- デバッグ用プロファイルで Medium.com にログイン済みであること

## 手順

### 1. MCP の利用可能確認

Chrome DevTools MCP のツールが利用可能か確認する。利用できない場合はユーザーに以下を案内する:

```
# デバッグ用 Chrome を起動（fish abbr）
chrome:debug

# MCP 未登録の場合
claude mcp add --transport stdio chrome-devtools -- npx -y chrome-devtools-mcp@latest --browserUrl=http://127.0.0.1:9222
```

### 2. 記事の取得

Chrome DevTools MCP のツールを使って:

1. `navigate_page` で ARGUMENTS の URL に遷移する
2. `evaluate_script` で記事本文を抽出する（**`take_snapshot` は使わない**）
3. 取得した内容をユーザーに提示する

### 3. 記事本文の抽出方法

**重要: `take_snapshot` は Medium 記事では 80,000 文字以上になりトークン上限を超えるため使用禁止。必ず `evaluate_script` を使う。**

以下の JavaScript で `<article>` 要素から本文テキストを抽出する:

```javascript
// 1回目: 記事の長さを確認し、最初の12,000文字を取得
() => {
  const article = document.querySelector('article');
  if (!article) return 'No article found';
  const text = article.innerText;
  return JSON.stringify({ totalLength: text.length, content: text.substring(0, 12000) });
}
```

12,000文字を超える場合は、残りを分割取得する:

```javascript
// 2回目以降: オフセットを12000ずつ増やして取得
(offset) => {
  const article = document.querySelector('article');
  if (!article) return '';
  return article.innerText.substring(offset, offset + 12000);
}
```

**1回の取得は12,000文字以内に収める**（APIレスポンスサイズ制限のため）。

### 4. コードブロックを含む記事の場合

`innerText` ではコードブロックのフォーマットが失われる場合がある。コードが重要な記事では以下で Markdown 風に取得できる:

```javascript
() => {
  const article = document.querySelector('article');
  if (!article) return 'No article found';
  // コードブロックを保持しつつテキスト抽出
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
  return result.substring(0, 12000);
}
```

## 注意事項

- **WebFetch は使用しない**（必ず失敗する）
- **`take_snapshot` は使用しない**（サイズ超過でエラーになる）
- 必ず `evaluate_script` で JavaScript 経由でテキストを抽出する
- 1回の取得は12,000文字以内に分割する
- Medium 以外のサイトはまず WebFetch を試み、失敗した場合にのみこのスキルを参照する
