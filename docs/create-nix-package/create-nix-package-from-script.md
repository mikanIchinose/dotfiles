# シェルスクリプトのNixパッケージ化

## ビルド方式の選択

| 方式 | 使用場面 |
|------|---------|
| `stdenv.mkDerivation` + `fetchFromGitHub` | GitHubリポジトリにあるスクリプト（推奨） |
| `writeShellApplication` | ローカルや簡易的なスクリプト |

> まず `nix eval nixpkgs#<pname>.version 2>/dev/null` で nixpkgs に既存パッケージがないか確認する。

---

## 方式1: `stdenv.mkDerivation`（推奨）

GitHub等からスクリプトを取得してパッケージ化する標準的な方法。
`makeWrapper` で依存ツールを PATH に注入する。

### テンプレート

```nix
# nix/packages/<pname>/default.nix
{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  # 依存ツールをここに列挙
  # gum,
  # git,
  # jq,
}:

stdenv.mkDerivation rec {
  pname = "<pname>";
  version = "<version>";

  src = fetchFromGitHub {
    owner = "<owner>";
    repo = "<repo>";
    rev = "v${version}";
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 <script-name> $out/bin/<script-name>
    wrapProgram $out/bin/<script-name> \
      --prefix PATH : ${
        lib.makeBinPath [
          # gum
          # git
          # jq
        ]
      }
    runHook postInstall
  '';

  meta = with lib; {
    description = "<description>";
    homepage = "https://github.com/<owner>/<repo>";
    license = licenses.mit;
    mainProgram = "<pname>";
  };
}
```

実例: [`nix/packages/gh-switch-issue/default.nix`](../nix/packages/gh-switch-issue/default.nix)

### ポイント

- `install -Dm755` でスクリプトに実行権限を付けてインストール
- `wrapProgram` + `lib.makeBinPath` で依存ツールの PATH を注入
- `nativeBuildInputs` に `makeWrapper` を追加（`wrapProgram` を使うために必要）

### バージョンなしリポジトリの場合

リリースタグがないリポジトリでは `version` と `rev` を以下のように書く:

```nix
version = "unstable-2024-03-10";

src = fetchFromGitHub {
  owner = "<owner>";
  repo = "<repo>";
  rev = "<commit-hash>";
  hash = lib.fakeHash;
};
```

### 複数スクリプトを含む場合

リポジトリに複数のスクリプトがある場合は `installPhase` で個別にインストールする:

```nix
installPhase = ''
  runHook preInstall
  install -Dm755 script-a $out/bin/script-a
  install -Dm755 script-b $out/bin/script-b
  wrapProgram $out/bin/script-a \
    --prefix PATH : ${lib.makeBinPath [ jq curl ]}
  wrapProgram $out/bin/script-b \
    --prefix PATH : ${lib.makeBinPath [ git ]}
  runHook postInstall
'';
```

すべてのスクリプトが同じ依存を持つ場合はループも可能:

```nix
installPhase = ''
  runHook preInstall
  for script in script-a script-b script-c; do
    install -Dm755 "$script" "$out/bin/$script"
    wrapProgram "$out/bin/$script" \
      --prefix PATH : ${lib.makeBinPath [ jq curl git ]}
  done
  runHook postInstall
'';
```

### シェル補完を追加する場合

```nix
{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  # ...

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  installPhase = ''
    runHook preInstall
    install -Dm755 <script-name> $out/bin/<script-name>
    wrapProgram $out/bin/<script-name> \
      --prefix PATH : ${lib.makeBinPath [ /* deps */ ]}

    # 補完ファイルがリポジトリに含まれている場合
    installShellCompletion --bash completions/<pname>.bash
    installShellCompletion --zsh  completions/_<pname>
    installShellCompletion --fish completions/<pname>.fish
    runHook postInstall
  '';
}
```

### `makeWrapper` のオプション

| オプション | 用途 | 例 |
|-----------|------|-----|
| `--prefix PATH :` | PATH に追加 | `--prefix PATH : ${lib.makeBinPath [ jq ]}` |
| `--set` | 環境変数を設定 | `--set MY_VAR "value"` |
| `--set-default` | 未設定時のみ設定 | `--set-default EDITOR "vim"` |
| `--suffix PATH :` | PATH の末尾に追加 | `--suffix PATH : ${lib.makeBinPath [ git ]}` |

---

## 方式2: `writeShellApplication`（簡易的な方法）

短いスクリプトやローカルで管理するスクリプトに向いている。
`fetchFromGitHub` を使わず、スクリプト本体を Nix 式内に直接記述する。

```nix
{ pkgs }:

pkgs.writeShellApplication {
  name = "<pname>";

  runtimeInputs = with pkgs; [
    jq
    curl
    git
  ];

  text = ''
    # スクリプト本体をここに記述
    echo "Hello, world!"
  '';
}
```

### `stdenv.mkDerivation` との比較

| 特徴 | `stdenv.mkDerivation` | `writeShellApplication` |
|------|----------------------|------------------------|
| スクリプトの管理場所 | 外部リポジトリ | Nix式内に直接記述 |
| 依存ツールの注入 | `makeWrapper` + `wrapProgram` | `runtimeInputs` |
| ShellCheck | なし | 自動適用 |
| 複数ファイル | 対応可能 | 単一スクリプト向き |
| update.sh | 対応可能 | バージョン管理不要 |
| 推奨場面 | GitHub上のスクリプト | 短いユーティリティ |

### 注意点

- `writeShellApplication` は `set -euo pipefail` を自動で先頭に挿入する
- スクリプト内で `$` を使う場合は `''$` とエスケープが必要
- `flake.nix` への登録方法は `stdenv.mkDerivation` と同じ

---

## ハッシュの取得

`lib.fakeHash` を仮入力してビルドすると、エラー出力に正しいハッシュが表示される。

```bash
nix build .#<pname> 2>&1 | grep "got:"
# → got: sha256-XXXX...  を hash = に設定
```

---

## flake.nix への登録

`perSystem` と overlay の両方に追加する:

```nix
# perSystem
packages.<pname> = pkgs.callPackage ./nix/packages/<pname> { };

# overlays-configuration の local packages
<pname> = final.callPackage ./nix/packages/<pname> { };
```

---

## update.sh の作成

`nix-update` を使った標準的なスクリプト:

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
pkg="$(basename "$(pwd)")"
nix run nixpkgs#nix-update -- --flake --override-filename "nix/packages/$pkg/default.nix" "$pkg"
```

```bash
chmod +x nix/packages/<pname>/update.sh
```

> バージョンなし（`unstable-*`）のパッケージでは `nix-update` が正しく動作しない場合がある。
> その場合は手動で `rev` と `hash` を更新する。

---

## home-manager.nix への追加

`nix/home-manager.nix` の適切なリストに追加する:

| カテゴリ | 追加先 |
|---------|--------|
| 自作・カスタムパッケージ | `selfPackages` |
| CLIユーティリティ | `utility` |
| 開発ツール全般 | `devtools` |
| LSP | `lsp` |
| Linter/Formatter | `linter` |

---

## 完了チェックリスト

- [ ] `nix eval nixpkgs#<pname>.version` で nixpkgs に既存パッケージがないか確認
- [ ] `nix/packages/<pname>/default.nix` を作成
- [ ] `flake.nix` の `perSystem` に追加
- [ ] `flake.nix` の overlay に追加
- [ ] `nix build .#<pname>` が成功する
- [ ] `nix/packages/<pname>/update.sh` を作成・実行権限付与
- [ ] `nix/home-manager.nix` の適切なリストに追加
