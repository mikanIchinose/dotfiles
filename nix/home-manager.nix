{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  username = "mikan";
in
{
  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
  ];
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    neovim
    curl
    git
    gh
    ghq
    delta
    go
    fish
    deno
    starship
    lazygit
    ripgrep
    ripgrep-all
    fd
    eza
    zoxide
    bat
    gum
    scrcpy
    desktop-file-utils
    rm-improved
    yazi
    nodejs
    fzf
    coreutils
    nixd
    nixfmt-rfc-style
    serie
    ffmpeg
    hyperfine
    clojure
    leiningen
    babashka
  ];
}
