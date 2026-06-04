{
  lib,
  pkgs,
  ...
}:
let
  ghqLib = import ../../ghq-repos.nix { inherit lib pkgs; };
  personalGhqRepos = [
    "mikanIchinose/CurriculumVitae"
    "mikanIchinose/google-play-staged-rollout-action"
    "mikanIchinose/note"
    "mikanIchinose/zenn-docs"
  ];
in
{
  home.packages = with pkgs; [
    gws
  ];
  home.activation = ghqLib.mkGhqActivation "personal" personalGhqRepos;
}
