{
  inputs,
  pkgs,
  ...
}:
let
  username = "mikan";
  nodePkgs = pkgs.callPackage ./node2nix {
    inherit pkgs;
    nodejs = pkgs.nodejs_24;
  };
  programming = with pkgs; [
    go
    deno
    nodejs
    bun
    clojure
    leiningen
    babashka
    uv
  ];
  lsp = with pkgs; [
    #rust-analyzer # https://github.com/NixOS/nixpkgs/issues/432960
    yaml-language-server
    efm-langserver
    nodePkgs."@github/copilot-language-server"
    nodePkgs.gh-actions-language-server
  ];
  formatter = with pkgs; [
  ];
  linter = with pkgs; [
    yamllint
    actionlint
  ];
  devtools-nix = with pkgs; [
    nixd
    nixfmt-rfc-style
  ];
  devtools-vim = with pkgs; [
    vim-language-server
    lua-language-server
    stylua
    luajitPackages.luacheck
  ];
  devtools-web = with pkgs; [
    emmet-language-server
    vtsls
    vscode-langservers-extracted
    vue-language-server
  ];
  devtools-clojure = with pkgs; [
    clojure-lsp
    clj-kondo
  ];
  utility = with pkgs; [
    neovim
    curl
    git
    ghq
    delta
    difftastic
    serie
    fish
    gum
    desktop-file-utils
    rm-improved
    coreutils
    ffmpeg
    hyperfine
    firebase-tools
    maestro
    tokei
    nodePkgs."@anthropic-ai/claude-code"
    nodePkgs.ccusage
    # scrcpy # unsupported arm64-apple
  ];
in
{
  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
  ];
  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.home-manager.enable = true;

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-poi
    ];
  };
  programs.zoxide.enable = true;
  programs.bat.enable = true;
  programs.starship.enable = true;
  programs.yazi.enable = true;
  programs.fd = {
    enable = true;
    hidden = true;
  };
  programs.eza.enable = true;
  programs.lazygit.enable = true;
  programs.ripgrep.enable = true;
  programs.ripgrep-all.enable = true;
  programs.fzf.enable = true;

  home.shell.enableFishIntegration = true;
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.05";
  home.packages =
    programming
    ++ lsp
    ++ formatter
    ++ linter
    ++ devtools-nix
    ++ devtools-vim
    ++ devtools-web
    ++ devtools-clojure
    ++ utility;
}
