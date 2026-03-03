# nix/ghq-repos.nix
{ lib, pkgs }:
let
  repos = [
    "mikanIchinose/kokoro-odoru-github"
    "mikanIchinose/note"
    "mikanIchinose/zenn-docs"
    "skk-dev/dict"
  ];
in
{
  activation.ghqGetRepos = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${
      lib.makeBinPath [
        pkgs.git
        pkgs.openssh
      ]
    }:$PATH"
    ghq_ok=0
    ghq_fail=0
    ghq_skip=0
    ghq_errors=""
    ${builtins.concatStringsSep "\n" (
      map (repo: ''
        if [ -d "$HOME/ghq/github.com/${repo}" ]; then
          ghq_skip=$((ghq_skip + 1))
        elif ${pkgs.ghq}/bin/ghq get --silent "https://github.com/${repo}" 2>&1; then
          ghq_ok=$((ghq_ok + 1))
        else
          ghq_fail=$((ghq_fail + 1))
          ghq_errors="$ghq_errors  - ${repo}\n"
        fi
      '') repos
    )}
    echo "ghq: cloned=$ghq_ok skipped=$ghq_skip failed=$ghq_fail total=${toString (builtins.length repos)}"
    if [ "$ghq_fail" -gt 0 ]; then
      printf "ghq: failed repositories:\n%b" "$ghq_errors"
    fi
  '';
}
