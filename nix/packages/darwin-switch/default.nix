{
  lib,
  writeShellApplication,
  git,
  nix,
}:

# darwin-switch: nix-darwin 設定を適用し、必要に応じて古い世代を GC する。
#
# nix.gc.automatic は nix.enable = false（nix-installer 管理）の環境では
# assertion (`nix.gc.automatic requires nix.enable`) により利用できない。
# そこで --gc 指定時は switch 後に root 権限で nix-collect-garbage を実行し、
# system profile の世代も含めて掃除する。通常の switch では、完了を待つ必要が
# ない GC をクリティカルパスから外す。
#
# Usage:
#   nix run .#darwin-switch -- personal              # personal 構成を適用
#   nix run .#darwin-switch -- s34580                # 社用構成を適用
#   nix run .#darwin-switch -- --update-flake <host> # flake.lock を更新してから適用
#   nix run .#darwin-switch -- --gc <host>           # 適用後に古い世代を GC
writeShellApplication {
  name = "darwin-switch";

  # darwin-rebuild と sudo は system PATH から解決する。
  runtimeInputs = [
    git
    nix
  ];

  text = ''
    GC_AGE="3d"

    UPDATE=0
    RUN_GC=0
    while [[ "''${1:-}" == --* ]]; do
      case "$1" in
        --update-flake)
          UPDATE=1
          ;;
        --gc)
          RUN_GC=1
          ;;
        *)
          echo "error: 不明なオプションです: $1" >&2
          echo "usage: darwin-switch [--update-flake] [--gc] <host>" >&2
          exit 1
          ;;
      esac
      shift
    done

    if [[ "$#" -ne 1 ]]; then
      echo "error: host を指定してください (例: personal, s34580)" >&2
      echo "usage: darwin-switch [--update-flake] [--gc] <host>" >&2
      exit 1
    fi
    HOST="$1"

    FLAKE_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    cd "$FLAKE_DIR"

    if [[ "$UPDATE" -eq 1 ]]; then
      echo "==> nix flake update"
      nix flake update
    fi

    # flake は git 管理下のファイルのみ参照するため、新規ファイルを stage しておく
    git add -A

    echo "==> darwin-rebuild switch --flake .#''${HOST}"
    if command -v darwin-rebuild >/dev/null 2>&1; then
      sudo darwin-rebuild switch --flake ".#''${HOST}"
    else
      sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ".#''${HOST}"
    fi

    if [[ "$RUN_GC" -eq 1 ]]; then
      echo "==> nix-collect-garbage --delete-older-than ''${GC_AGE} (root)"
      sudo nix-collect-garbage --delete-older-than "''${GC_AGE}"
    fi

    echo "==> done"
  '';

  meta = with lib; {
    description = "Apply nix-darwin configuration and optionally GC old generations";
    license = licenses.mit;
    mainProgram = "darwin-switch";
  };
}
