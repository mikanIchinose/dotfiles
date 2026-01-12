---
name: analyze-component-behaviors
description: This skill shoudl be used when the user ask to "behaviors", "specification", "read implementation", "analyze component", "振る舞いを分析", "振る舞いを理解". Analyze component(module, package, class, function) behaviors and output as a Markdown file.
---

<purpose>
コンポーネント（モジュール、パッケージ、クラス、関数）の振る舞いを分析し、実装計画、新機能の作成、バグ修正、テスト改善などに活用する。
最終的にMarkdownファイルとしてレポートを出力する。
</purpose>

<classification-criteria>
## 分類基準

### 外部から観測可能な振る舞い (Observable)
公開インターフェースを通じて検証可能な振る舞い:
- 戻り値の内容・形式
- 例外/エラーの発生
- 外部に公開される副作用（キャッシュの更新、API呼び出しなど）
- パブリックプロパティの変更

**テスト優先度**: 必須 - 公開契約として維持が必要
**リファクタリング時**: 変更不可（破壊的変更となる）

### 実装の詳細 (Internal)
内部実装の選択であり、外部から直接観測できない振る舞い:
- 内部アルゴリズムの選択
- プライベートメソッドの処理順序
- 内部データ構造の選択
- パフォーマンス最適化の実装方法

**テスト優先度**: 禁止 - 実装詳細のテストはリファクタリングを妨げる
**リファクタリング時**: 外部契約を維持する限り変更可能
</classification-criteria>

<input>
component: 分析対象のコンポーネント ex. ItemRepositoryImpl
</input>

<output>
{component}.behaviors.md（リポジトリルートに配置）
</output>

<workflow name="Analyze Component Behaviors">

<steps name="Phase 1: Analyze">
<step name="1. Analyze Public Interface">
コンポーネントの公開情報を分析する。
- クラス名
- メソッド名
- メソッドパラメータ
- 戻り値
- プロパティ
- コンストラクタ
</step>

<step name="2. Analyze Implementation Details">
コンポーネント内にカプセル化された実装の詳細を分析する。
- メソッド内でどのような処理が実行されるか？
- 引数としてどのような具体的な値が渡されることが期待されるか？
</step>

<step name="3. Review Existing Tests" optional="true" condition="tests exist for the system under test">
テストケースで検証されている振る舞いを確認する。
- どの振る舞いが既にテストでカバーされているかを特定する
- テストメソッド名と検証内容をメモする
</step>
</steps>

<steps name="Phase 2: Discover">
<step name="4. List and Classify Behaviors">
コンポーネントの振る舞いをリストアップし、それぞれを分類する。
- 非エンジニアにもわかりやすい言葉で振る舞いを記述する
- 振る舞いが実装されている行番号を含める
- 機能領域（例：データ取得、バリデーション、変換）でカテゴリ分けする
- **各振る舞いをObservableまたはInternalに分類する**:
  - Observable: 公開インターフェースを通じて検証可能（戻り値、例外、可視的な副作用）
  - Internal: 外部から直接観測できない実装の選択
</step>
</steps>

<steps name="Phase 3: Output">
<step name="5. Export Results">
結果を日本語でMarkdownファイルとして出力する。
- 配置場所: リポジトリルート
- ファイル名: {component}.behaviors.md
</step>
</steps>

</workflow>

<output-format>
# {Component} の振る舞い

## 概要

{コンポーネントの役割と責務の簡潔な説明}

## Public Interface

### クラス定義
- クラス名: {ClassName}
- パッケージ: {package.name}

### コンストラクタ
- {コンストラクタの説明}

### プロパティ
| プロパティ名 | 型 | 説明 |
|-------------|-----|------|
| {name} | {type} | {description} |

### メソッド
| メソッド名 | パラメータ | 戻り値 | 説明 |
|-----------|-----------|--------|------|
| {name} | {params} | {return} | {description} |

## 振る舞い

| # | 振る舞い | 振る舞い(非エンジニア向け) | 分類 | 実装箇所 |
|---|---------|--------------------------|------|---------｜
| 1 | {振る舞いの説明} | {振る舞いの説明（非エンジニア向け）} | Observable | {filename}:{line} |
| 2 | {振る舞いの説明} | {振る舞いの説明（非エンジニア向け）} | Internal | {filename}:{line} |

## 既存テストでカバーされている振る舞い

| # | テストケース | 検証している振る舞い |
|---|-------------|-------------------|
| 1 | {テスト名} | {振る舞いの説明} |

## 未テストの振る舞い

| # | 振る舞い | 分類 | テスト推奨度 |
|---|---------|------|-------------|
| 1 | {振る舞いの説明} | Observable | 必須 |
| 2 | {振る舞いの説明} | Internal | 禁止 |
</output-format>

<notes>
- 振る舞いの説明には動詞の終止形を使用する（例：「〜する」「〜を返す」「〜を検証する」）
- 行番号は分析時点のものであり、コード変更により変わる可能性がある
- 機能単位でカテゴリ分けする（例：データ取得、バリデーション、変換）
- 分類の判断基準:
  - Observable: 公開メソッドの戻り値、スローされる例外、可視的な副作用（キャッシュ更新、API呼び出しなど）
  - Internal: プライベートメソッドの詳細、内部状態の管理方法、最適化手法
- 境界ケース: キャッシュ更新は「外部から観測可能な副作用」としてObservableに分類
</notes>
