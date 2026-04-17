{
  lib,
  pkgs,
  ...
}:
let
  ghqLib = import ../../ghq-repos.nix { inherit lib pkgs; };
  workGhqRepos = [
    "karabiner-inc/tokushimaru_diver_app"
    "Oisix/claude-plugins"
    "Oisix/oisix-app-playground"
    "Oisix/oisix-mobile-migrator"
    "Oisix/oisix-snowflake-query-tools"
    "Oisix/oisixAndroid"
    "Oisix/oisixiOS"
  ];
in
{
  home.packages = with pkgs; [
    git-filter-repo
  ];

  home.activation = ghqLib.mkGhqActivation "work" workGhqRepos;
}
