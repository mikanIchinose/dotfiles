# git ワークフロー

### 手順

1. `git status` で変更ファイルを確認する
2. `git diff` または `git diff --cached` で変更内容を確認する
3. 必要に応じて `git add <file>` でステージングする
4. 変更内容を分析し、Conventional Commits 形式でコミットメッセージを構築する
5. コミットを実行する

### コミット実行

```xml
<final-step>
	<cmd>git commit -m "type(scope): description"</cmd>
	<note>構築したメッセージで置き換える。body や footer が必要な場合は複数の -m フラグを使用する。</note>
</final-step>
```
