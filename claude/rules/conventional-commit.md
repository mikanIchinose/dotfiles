# コミットメッセージ構造

```
<type>(scope): <description>

<optional body>
<optional footer>
```

```xml
<commit-message>
	<type>feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert</type>
	<scope>変更対象の範囲（任意）</scope>
	<description>変更内容の簡潔な要約（命令形の動詞で始める）</description>
	<body>詳細な説明（任意）</body>
	<footer>破壊的変更や issue 参照（任意）</footer>
</commit-message>
```

## type 一覧

```xml
<types>
	<type name="feat">新機能</type>
	<type name="fix">バグ修正</type>
	<type name="docs">ドキュメントのみの変更</type>
	<type name="style">コードの意味に影響しない変更（空白、フォーマット等）</type>
	<type name="refactor">バグ修正でも機能追加でもないコード変更</type>
	<type name="perf">パフォーマンス改善</type>
	<type name="test">テストの追加・修正</type>
	<type name="build">ビルドシステムや外部依存関係の変更</type>
	<type name="ci">CI 設定の変更</type>
	<type name="chore">その他の変更</type>
	<type name="revert">コミットの取り消し</type>
</types>
```

## 例

```
feat(parser): 配列のパース機能を追加
```

```
fix(ui): ボタンの配置を修正
```

```
docs: README に使い方を追記
```

```
refactor: データ処理のパフォーマンスを改善
```

```
chore: 依存関係を更新
```

```
feat!: 登録時にメール送信を追加

BREAKING CHANGE: メールサービスが必要
```

## バリデーション

```xml
<validation>
	<type>許可された type のいずれかであること。参照: <reference>https://www.conventionalcommits.org/en/v1.0.0/#specification</reference></type>
	<scope>任意。明確さのため推奨。</scope>
	<description>必須。命令形を使用（例: "add" であって "added" ではない）。</description>
	<body>任意。変更の動機や追加の文脈を記述。</body>
	<footer>破壊的変更（BREAKING CHANGE）や issue 参照に使用。</footer>
</validation>
```

