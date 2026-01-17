# gh release - リリース管理

## リリース作成

```bash
# 基本的なリリース作成
gh release create v1.0.0

# リリースノート自動生成
gh release create v1.0.0 --generate-notes

# ドラフト・プレリリース
gh release create v1.0.0 --draft
gh release create v1.0.0 --prerelease
gh release create v1.0.0 --draft --prerelease

# タイトル・本文指定
gh release create v1.0.0 --title "Release v1.0.0" --notes "Release notes here"
gh release create v1.0.0 --notes-file CHANGELOG.md
```

## アセット付きリリース

```bash
# ファイルをアセットとして添付
gh release create v1.0.0 ./dist/*.tar.gz
gh release create v1.0.0 ./build/app.zip ./build/app.dmg
```

## リリース編集

```bash
# リリースノート編集
gh release edit v1.0.0 --notes "Updated notes"

# ドラフトを公開
gh release edit v1.0.0 --draft=false

# プレリリースを正式版に
gh release edit v1.0.0 --prerelease=false
```

## リリース表示・ダウンロード

```bash
# 最新リリースの情報
gh release view
gh release view --json tagName,publishedAt

# 特定バージョンの情報
gh release view v1.0.0

# アセットのダウンロード
gh release download v1.0.0
gh release download v1.0.0 --pattern "*.tar.gz"
gh release download v1.0.0 --dir ./downloads
```

## リリース一覧・削除

```bash
# リリース一覧
gh release list

# リリース削除
gh release delete v1.0.0
gh release delete v1.0.0 --yes  # 確認スキップ
```
