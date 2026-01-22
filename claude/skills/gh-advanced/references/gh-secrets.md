# gh secret / gh variable - シークレット・変数管理

## gh secret - シークレット管理

### リポジトリシークレット

```bash
gh secret set SECRET_NAME
gh secret set SECRET_NAME < secret.txt
gh secret set SECRET_NAME --body "value"
gh secret list
gh secret delete SECRET_NAME
```

### 環境シークレット

```bash
gh secret set SECRET_NAME --env production
```

### Organization シークレット

```bash
gh secret set SECRET_NAME --org my-org --visibility all
gh secret set SECRET_NAME --org my-org --visibility selected --repos repo1,repo2
```

### アプリケーション指定

```bash
# actions, codespaces, dependabot から選択
gh secret set SECRET_NAME --app codespaces
gh secret set SECRET_NAME --app dependabot
```

### 一括設定

```bash
# dotenv ファイルから一括設定
gh secret set -f .env.production
```

## gh variable - 変数管理

### リポジトリ変数

```bash
gh variable set VAR_NAME --body "value"
gh variable list
gh variable delete VAR_NAME
```

### 環境変数

```bash
gh variable set VAR_NAME --env production --body "value"
```

### Organization 変数

```bash
gh variable set VAR_NAME --org my-org --visibility all
gh variable set VAR_NAME --org my-org --visibility selected --repos repo1,repo2
```

### 一括設定

```bash
# dotenv ファイルから一括設定
gh variable set -f .env
```
