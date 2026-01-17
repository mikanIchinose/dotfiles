# その他のコマンド

## gh project - GitHub Projects 操作

```bash
# プロジェクト一覧
gh project list
gh project list --owner @me

# プロジェクト作成
gh project create --owner @me --title "Roadmap"

# プロジェクト表示
gh project view {number} --owner @me
gh project view {number} --owner @me --web

# アイテム一覧
gh project item-list {number} --owner @me

# アイテム追加（Issue/PR をプロジェクトに追加）
gh project item-add {number} --owner @me --url {issue-or-pr-url}

# フィールド一覧
gh project field-list {number} --owner @me
```

## gh ruleset - ルールセット管理

```bash
# ルールセット一覧
gh ruleset list

# ルールセット表示
gh ruleset view {ruleset-id}
gh ruleset view {ruleset-id} --web

# ブランチがルールに適合するか確認
gh ruleset check {branch-name}
```

## gh attestation - アーティファクト検証

サプライチェーンセキュリティのための成果物検証。

```bash
# 認証証明書のダウンロード
gh attestation download {artifact-path}

# アーティファクトの検証
gh attestation verify {artifact-path} --owner {owner}

# 信頼されたルート情報の取得
gh attestation trusted-root
```

## gh extension - 拡張機能

```bash
# 拡張機能のインストール
gh extension install owner/gh-extension-name

# 人気の拡張機能
gh extension install dlvhdr/gh-dash      # TUI ダッシュボード
gh extension install seachicken/gh-poi   # ブランチ整理
gh extension install mislav/gh-branch    # ブランチ管理

# 拡張機能の管理
gh extension list
gh extension upgrade --all
gh extension remove extension-name
```

## gh alias - エイリアス設定

```bash
# エイリアス作成
gh alias set pv 'pr view'
gh alias set co 'pr checkout'
gh alias set mypr 'pr list --author @me'

# シェルコマンドを含むエイリアス
gh alias set --shell igrep 'gh issue list | grep "$1"'

# エイリアス一覧
gh alias list

# エイリアス削除
gh alias delete pv
```

## gh codespace - Codespaces 操作

```bash
# Codespace 作成
gh codespace create --repo owner/repo
gh codespace create --machine largeMachine

# Codespace 一覧
gh codespace list

# Codespace に接続
gh codespace ssh
gh codespace code  # VS Code で開く

# ポートフォワーディング（remote:local 形式）
gh codespace ports forward 8080:3000

# Codespace 削除
gh codespace delete --all
```

## gh gist - Gist 操作

```bash
# Gist 作成
gh gist create file.txt
gh gist create file1.txt file2.txt --public
gh gist create - --filename stdin.txt  # stdin から

# Gist 編集
gh gist edit {gist-id}

# Gist クローン
gh gist clone {gist-id}
```
