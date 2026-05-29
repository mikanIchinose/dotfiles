# GitHub Actions 関連コマンド

## gh run - ワークフロー実行操作

```bash
# 実行一覧
gh run list
gh run list --workflow build.yml --branch main
gh run list --status failure --limit 5

# 実行中のワークフローをウォッチ
gh run watch {run-id}
gh run watch {run-id} --exit-status  # 失敗時に非ゼロ終了

# 失敗したジョブのみ再実行
gh run rerun {run-id} --failed

# 特定ジョブのログを表示
gh run view {run-id} --log --job {job-id}

# ワークフロー実行のキャンセル
gh run cancel {run-id}

# アーティファクトのダウンロード
gh run download {run-id} -n artifact-name
```

## gh workflow - ワークフロー管理

```bash
# ワークフロー一覧
gh workflow list
gh workflow list --all  # 無効化されたものも含む

# ワークフローの詳細表示
gh workflow view {workflow-name}
gh workflow view {workflow-name} --yaml  # YAML を表示

# ワークフローを手動実行（inputs 付き）
gh workflow run deploy.yml -f environment=staging -f version=1.2.3
gh workflow run deploy.yml --ref feature-branch

# ワークフローの有効化・無効化
gh workflow enable {workflow-name}
gh workflow disable {workflow-name}
```

## gh cache - Actions キャッシュ管理

```bash
# キャッシュ一覧
gh cache list

# キャッシュ削除
gh cache delete {cache-id}
gh cache delete --all
```
