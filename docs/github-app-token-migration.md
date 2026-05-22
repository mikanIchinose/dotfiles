# GitHub App トークンへの移行手順

`secrets.WORKFLOW_PAT`（Fine-grained PAT）に依存していた以下のワークフローを、GitHub App + `actions/create-github-app-token` による一時トークンに置き換えるための手順書。

対象ワークフロー:
- `.github/workflows/update-flake.yml`
- `.github/workflows/update-packages.yml`

## なぜ移行するのか

| 項目 | PAT | GitHub App トークン |
|------|-----|---------------------|
| 有効期限 | 必須（最長 1 年）、切れたら CI 停止 | Installation token は **1 時間で自動失効** |
| ローテーション | 手動更新が必要 | 不要（毎回ワークフロー実行時に生成） |
| 権限スコープ | ユーザー単位 | リポジトリ単位 |
| 漏えい時の影響 | トークン寿命の間ずっと危険 | 1 時間で自動的に無効化 |

秘密鍵自体は無期限なので、**秘密鍵さえ漏らさなければローテーション運用が不要** になる。

## ワークフロー側の変更内容（実施済み）

`actions/create-github-app-token` で都度トークンを発行し、後続ステップで利用するよう変更済み。

```yaml
- name: Generate GitHub App token
  id: app-token
  uses: actions/create-github-app-token@bcd2ba49218906704ab6c1aa796996da409d3eb1 # v3.2.0
  with:
    client-id: ${{ secrets.WORKFLOW_APP_CLIENT_ID }}
    private-key: ${{ secrets.WORKFLOW_APP_PRIVATE_KEY }}

- uses: actions/checkout@...
  with:
    token: ${{ steps.app-token.outputs.token }}
```

このトークンはワークフロー終了時に自動失効する（明示的な revoke を入れる場合は末尾の「補足」を参照）。

## ユーザー側の作業（要対応）

以下は GitHub の Web UI 操作が必要なため、ユーザーが手動で実施する。

### 1. GitHub App を作成

1. <https://github.com/settings/apps/new> を開く
2. 以下を設定:
   - **GitHub App name**: 例 `mikanichinose-dotfiles-bot`（グローバルで一意）
   - **Homepage URL**: 任意（例 `https://github.com/mikanIchinose/dotfiles`）
   - **Webhook → Active**: チェックを **外す**
   - **Repository permissions**:
     - `Contents`: **Read and write** （push に必要）
     - `Pull requests`: **Read and write** （PR 作成・マージに必要 / `update-packages.yml` 用）
     - `Metadata`: **Read-only**（デフォルトで自動付与）
   - **Where can this GitHub App be installed?**: `Only on this account`
3. `Create GitHub App` をクリック

### 2. Client ID をメモ

作成後の App 管理ページ上部 `About` セクションに `Client ID: Iv23li...` と表示されるのでコピーする。

（同セクションに `App ID: 123456` も表示されるが、`actions/create-github-app-token` v3 以降では `app-id` が deprecated になっており `client-id` 推奨）

### 3. 秘密鍵を生成

1. 同ページ下部の `Private keys` セクションで `Generate a private key` をクリック
2. `.pem` ファイルがダウンロードされる
3. **ファイル内容を後でコピペできるよう一時的に保持**（外部ストレージ・クラウド同期フォルダには置かない）

### 4. リポジトリへインストール

1. 左メニュー `Install App` を選択
2. 自分のアカウントの `Install` をクリック
3. `Only select repositories` を選択し、`mikanIchinose/dotfiles` を選択
4. `Install` で確定

### 5. リポジトリの Secrets に登録

リポジトリの `Settings → Secrets and variables → Actions → New repository secret` から以下 2 つを登録:

| Secret 名 | 値 |
|-----------|-----|
| `WORKFLOW_APP_CLIENT_ID` | 手順 2 でメモした Client ID（`Iv23li...` 形式の文字列） |
| `WORKFLOW_APP_PRIVATE_KEY` | 手順 3 でダウンロードした `.pem` の **全文**（`-----BEGIN RSA PRIVATE KEY-----` から `-----END RSA PRIVATE KEY-----` まで含む） |

登録後、**ダウンロードした `.pem` ファイルはローカルから削除**する。

CLI で登録する場合（要 `gh auth refresh -s repo` 等で権限付与済み）:

```bash
gh secret set WORKFLOW_APP_CLIENT_ID --repo mikanIchinose/dotfiles --body 'Iv23li...'
gh secret set WORKFLOW_APP_PRIVATE_KEY --repo mikanIchinose/dotfiles < /path/to/private-key.pem
```

### 6. 動作確認

```bash
gh workflow run update-flake.yml --repo mikanIchinose/dotfiles
gh run watch --repo mikanIchinose/dotfiles
```

`Generate GitHub App token` ステップが緑になれば成功。

### 7. 旧 PAT を撤去

すべてのワークフローが新方式で動くことを確認したら:

1. `Settings → Secrets and variables → Actions` から `WORKFLOW_PAT` を削除
2. GitHub の `Settings → Developer settings → Personal access tokens` で当該 PAT を `Revoke` する

## 補足

### トークンを明示的に revoke したい場合

1 時間で自動失効するため通常は不要だが、念のため即時失効させたい場合は末尾に以下を追加:

```yaml
- name: Revoke GitHub App token
  if: ${{ always() }}
  env:
    GITHUB_TOKEN: ${{ steps.app-token.outputs.token }}
  run: |
    curl -X DELETE \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
      "${GITHUB_API_URL}/installation/token"
```

### bot コミットの author を App に揃える場合

`actions/create-github-app-token` の出力 `app-slug` を使って commit author を `<app-slug>[bot]` にすると、Web UI で App アイコン付きコミットになる。`update-flake.yml` の `Setup git` を以下に変えればよい:

```yaml
- name: Setup git
  env:
    APP_SLUG: ${{ steps.app-token.outputs.app-slug }}
  run: |
    user_id=$(gh api "/users/${APP_SLUG}[bot]" --jq .id)
    git config --local user.name "${APP_SLUG}[bot]"
    git config --local user.email "${user_id}+${APP_SLUG}[bot]@users.noreply.github.com"
```

### サードパーティアクションを避けたい場合

リファレンス記事（<https://zenn.dev/tmknom/articles/github-apps-token>）では `openssl + curl` でトークン生成を自前実装することを推奨している。`actions/create-github-app-token` は GitHub 公式（`actions/` org 配下）なので本手順では採用したが、サプライチェーン攻撃を避けたい場合は記事の bash 実装に差し替えても良い。
