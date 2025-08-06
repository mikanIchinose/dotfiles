{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  username = "mikan";
  lsp = with pkgs; [
    nixd
    clojure-lsp
    rust-analyzer
    emmet-language-server
    lua-language-server
    vtsls
    vscode-langservers-extracted
    yaml-language-server
    vue-language-server
    vim-language-server
  ];
  formatter = with pkgs; [
    nixfmt-rfc-style
  ];
  linter = with pkgs; [
    clj-kondo
  ];
in
{
  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
  ];
  nixpkgs.config = {
    allowUnfree = true;
  };
  programs.neovim = {
    enable = true;
    extraPackages = lsp ++ formatter ++ linter;
  };
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
    serie
    ffmpeg
    hyperfine
    clojure
    leiningen
    babashka
    firebase-tools
    difftastic
    fortune
    uv
    maestro
    tokei
    bun
  ];
}
