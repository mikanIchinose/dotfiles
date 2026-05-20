{
  lib,
  pkgs,
  ...
}:
let
  ghqLib = import ../../ghq-repos.nix { inherit lib pkgs; };
  workGhqRepos = [
  ];
in
{
  home.packages = with pkgs; [
    git-filter-repo
  ];

  home.activation = ghqLib.mkGhqActivation "work" workGhqRepos;
}
