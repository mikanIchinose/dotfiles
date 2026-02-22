---
name: improve-test-coverage
description: 複数のエージェントを使って対象コンポーネントのテストカバレッジを改善する。「テストカバレッジ改善」「improve test coverage」と依頼された際に使用。
argument-hint: <target-component> ex. modules/box/src/main/kotlin/.../BoxRepositoryImpl.kt
---

指定されたコンポーネントのテストカバレッジを改善します。
各Phaseで専用のSubAgentを起動し、レビュー→改善ループを回します。

## 入力
$ARGUMENTS

---

## Phase 1: 振る舞い分析

### Step 1.1: 分析実行
**Task toolで以下のSubAgentを起動:**
```
subagent_type: general-purpose
description: 振る舞い分析を実行
prompt: |
  以下のコンポーネントの振る舞いを分析してください。

  対象: $ARGUMENTS

  手順:
  1. `analyze-component-behaviors` スキルを実行
  2. 分析レポートをMarkdownファイルとして出力

  出力先: docs/behaviors/ ディレクトリ
```

### Step 1.2: レビュー＆改善ループ
**Task toolで以下のSubAgentを起動:**
```
subagent_type: general-purpose
description: 振る舞い分析をレビュー
prompt: |
  Phase 1で作成した振る舞い分析レポートをレビューしてください。

  対象ファイル: {Step 1.1で出力されたファイルパス}

  手順:
  1. `codex-review` スキルを実行してレビュー
  2. レビュー観点:
     - 全てのpublic APIが分析されているか
     - 副作用や状態変更が漏れなく記載されているか
     - エッジケースや境界条件が考慮されているか
  3. 指摘がある場合 → 分析レポートを改善
  4. 再度 `codex-review` を実行
  5. 指摘がなくなるまで繰り返す（最大3回）
```

---

## Phase 2: テスト計画書作成

### Step 2.1: 計画書作成
**Task toolで以下のSubAgentを起動:**
```
subagent_type: general-purpose
description: テスト計画書を作成
prompt: |
  振る舞い分析をもとにテスト計画書を作成してください。

  入力: {Phase 1で作成した振る舞い分析レポートのパス}

  手順:
  1. `test-guideline` スキルを実行してガイドラインを確認
  2. `plan-improve-test` スキルを実行
  3. 振る舞い分析レポートを入力として渡す

  出力先: docs/test-plans/ ディレクトリ
```

### Step 2.2: レビュー＆改善ループ
**Task toolで以下のSubAgentを起動:**
```
subagent_type: general-purpose
description: テスト計画書をレビュー
prompt: |
  Phase 2で作成したテスト計画書をレビューしてください。

  対象ファイル: {Step 2.1で出力されたファイルパス}

  手順:
  1. `codex-review` スキルを実行してレビュー
  2. レビュー観点:
     - test-guidelineに沿っているか
     - 振る舞い分析の全項目がカバーされているか
     - テストケースが具体的で実装可能か
  3. 指摘がある場合 → 計画書を改善
  4. 再度 `codex-review` を実行
  5. 指摘がなくなるまで繰り返す（最大3回）
```

---

## Phase 3: テスト実装

### Step 3.1: テスト実装
**Task toolで以下のSubAgentを起動:**
```
subagent_type: general-purpose
description: テストを実装
prompt: |
  テスト計画書をもとにテストを実装してください。

  入力: {Phase 2で作成したテスト計画書のパス}

  手順:
  1. `test-guideline` スキルを実行（必須）
  2. `implement-test` スキルを実行
  3. TDDアプローチで進める（Red → Green → Refactor）
  4. 論理的な単位で実装
```

### Step 3.2: レビュー＆改善ループ
**Task toolで以下のSubAgentを起動:**
```
subagent_type: general-purpose
description: テスト実装をレビュー
prompt: |
  Phase 3で実装したテストコードをレビューしてください。

  対象ファイル: {Step 3.1で実装されたテストファイル}

  手順:
  1. `codex-review` スキルを実行してレビュー
  2. レビュー観点:
     - test-guidelineに準拠しているか
     - テスト計画どおりに実装されているか
     - Arrange-Act-Assertパターンの適用
     - テストの可読性・保守性
  3. 指摘がある場合 → テストコードを改善
  4. 再度 `codex-review` を実行
  5. 指摘がなくなるまで繰り返す（最大3回）
```

---

## 実行指示

1. 各Stepは順番に実行する（並列実行しない）
2. 各SubAgentの完了を待ってから次のSubAgentを起動する
3. SubAgent間で成果物のパスを引き継ぐ
4. レビューループは最大3回までとし、それ以上はユーザーに判断を仰ぐ
