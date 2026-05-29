---
name: conventional-commit
description: '変更内容を確認し、Conventional Commits 形式のコミットメッセージを生成してコミットする。「コミットして」「commit」「jj commit」と依頼された際に使用。'
allowed-tools: Read, Bash(bash **/scripts/detect-vcs.sh), Bash(jj st), Bash(jj *), Bash(git status), Bash(git *)
---

### 説明

```xml
<description>変更内容を分析し、Conventional Commits 仕様に準拠したコミットメッセージを生成してコミットするワークフロー。git / jj 両方に対応。</description>
```

### VCS の判定

```xml
<vcs-detection>
	<script>bash scripts/detect-vcs.sh</script>
	<rule>スクリプトが "jj" を返した場合 → jj ワークフロー (references/jj.md)</rule>
	<rule>スクリプトが "git" を返した場合 → git ワークフロー (references/git.md)</rule>
	<important>判定後、該当するリファレンスファイルを必ず Read で読み込み、記載された手順に従うこと。自己判断でコマンドを実行しない。</important>
</vcs-detection>
```

### コミットメッセージ構造

```xml
<commit-message>
	<type>feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert</type>
	<scope>変更対象の範囲（任意）</scope>
	<description>変更内容の簡潔な要約（命令形の動詞で始める）</description>
	<body>詳細な説明（任意）</body>
	<footer>破壊的変更や issue 参照（任意）</footer>
</commit-message>
```

### type 一覧

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

### 例

```xml
<examples>
	<example>
		<description>配列パースの新機能追加</description>
		<message>feat(parser): 配列のパース機能を追加</message>
	</example>
	<example>
		<description>UI のボタン配置を修正</description>
		<message>fix(ui): ボタンの配置を修正</message>
	</example>
	<example>
		<description>README に使い方を追記</description>
		<message>docs: README に使い方を追記</message>
	</example>
	<example>
		<description>データ処理のパフォーマンス改善</description>
		<message>refactor: データ処理のパフォーマンスを改善</message>
	</example>
	<example>
		<description>依存関係の更新</description>
		<message>chore: 依存関係を更新</message>
	</example>
	<example>
		<description>破壊的変更を含む場合</description>
		<message>feat!: 登録時にメール送信を追加

BREAKING CHANGE: メールサービスが必要</message>
	</example>
</examples>
```

### バリデーション

```xml
<validation>
	<type>許可された type のいずれかであること。参照: <reference>https://www.conventionalcommits.org/en/v1.0.0/#specification</reference></type>
	<scope>任意。明確さのため推奨。</scope>
	<description>必須。命令形を使用（例: "add" であって "added" ではない）。</description>
	<body>任意。変更の動機や追加の文脈を記述。</body>
	<footer>破壊的変更（BREAKING CHANGE）や issue 参照に使用。</footer>
</validation>
```
