{
  lib,
  pkgs,
  ...
}:
let
  ghqLib = import ../../ghq-repos.nix { inherit lib pkgs; };
  workGhqRepos = [
    "Oisix/oisixAndroid"
    "Oisix/oisixiOS"
    "Oisix/oisix-mobile-migrator"
    "Oisix/oisix-app-playground"
    "Oisix/claude-plugins"
    "karabiner-inc/tokushimaru_diver_app"
  ];
in
{
  home.packages = with pkgs; [
    git-filter-repo
  ];

  home.activation = ghqLib.mkGhqActivation "work" workGhqRepos;
}
