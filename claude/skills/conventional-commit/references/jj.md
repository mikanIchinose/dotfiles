# jj (Jujutsu) ワークフロー

### 前提

```xml
<prerequisites>
	<note>jj にはステージングの概念がない。変更は即座にワーキングコピーに反映される。</note>
	<note>git コマンドは使わない。すべて jj コマンドを使用する。</note>
	<note>jj describe でメッセージを設定し、jj new で次の変更を開始する。</note>
</prerequisites>
```

### 手順

1. `jj st` で変更ファイルを確認する
2. `jj diff` で変更内容を確認する
3. `jj log -r @` で現在の変更の状態を確認する
4. 変更内容を分析し、Conventional Commits 形式でコミットメッセージを構築する
5. `jj describe -m "message"` でメッセージを設定する
6. 必要に応じて `jj new` で次の変更を開始する

### 変更の分割が必要な場合

```xml
<splitting>
	<case>1つの変更に複数の論理的な変更が含まれる場合</case>
	<action>jj split で変更を分割してから、それぞれに適切なメッセージを設定する</action>
	<cmd>jj split</cmd>
	<cmd>jj describe -m "type(scope): first change"</cmd>
	<cmd>jj describe @+ -m "type(scope): second change"</cmd>
</splitting>
```

### メッセージ設定

```xml
<final-step>
	<cmd>jj describe -m "type(scope): description"</cmd>
	<note>構築したメッセージで置き換える。body や footer が必要な場合は複数の -m フラグを使用する。</note>
	<note>メッセージ設定後、必要に応じて jj new で次の変更を開始する。</note>
</final-step>
```
