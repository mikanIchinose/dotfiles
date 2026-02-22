## プリビルドバイナリ向けワークフロー

### テンプレートを一括生成

`init-binary.sh` がリリース情報取得・ハッシュ取得・ファイル生成を一括で行う。

```bash
bash .claude/skills/create-nix-package/scripts/init-binary.sh <pname> <owner> <repo>
```

### installPhase を確認・調整

生成された `default.nix` の `installPhase` はパターン1（ルート直下）をデフォルトとする。
`nix build` 後にエラーが出た場合は展開後のファイル構造を確認して調整する。

| パターン | 状況 | installPhase |
|---------|------|-------------|
| 1: ルート直下 | バイナリが展開ルートにある | `cp <pname> $out/bin/` |
| 2: サブディレクトリ | `<pname>-v<version>/bin/<pname>` | `cp <pname>-v${version}/bin/<pname> $out/bin/` |
| 3: 複数ファイル | シェル補完等を含む | bin + share/zsh/site-functions + share/fish/vendor_completions.d |
| 4: 展開無効 | バイナリ単体ダウンロード | `dontUnpack = true;` + `install -m 755 $src $out/bin/<pname>` |

**パターン4（自動展開無効）:**

```nix
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 $src $out/bin/<pname>
  '';
```

### flake.nix に登録

`perSystem` と overlay の両方に追加する:

```nix
# perSystem
packages.<pname> = pkgs.callPackage ./nix/packages/<pname> { };

# overlay (overlays-configuration の local packages)
<pname> = final.callPackage ./nix/packages/<pname> { };
```

### nix build でビルド確認

```bash
nix build .#<pname> 2>&1
```

失敗した場合は `installPhase` パターンを調整する（ステップ 3 参照）。

### home-manager.nix に追加

`nix/home-manager.nix` の適切なリストに追加する

## 完了チェックリスト

- [ ] `nix eval nixpkgs#<pname>.version` で nixpkgs に既存パッケージがないか確認
- [ ] `init-binary.sh` でテンプレート生成
- [ ] `installPhase` を確認・調整
- [ ] `flake.nix` の `perSystem` に追加
- [ ] `flake.nix` の overlay に追加
- [ ] `nix build .#<pname>` が成功する
- [ ] `nix/home-manager.nix` の適切なリストに追加
