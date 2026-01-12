{
  inputs,
  pkgs,
  ...
}:
let
  selfPackages = with pkgs; [ gwq ];
  nodePkgs = pkgs.callPackage ./node2nix {
    inherit pkgs;
    nodejs = pkgs.nodejs_24;
  };
  programming = with pkgs; [
    deno
    nodejs
    bun
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
    # actionlint
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
    clojure
    leiningen
    babashka
    clojure-lsp
    clj-kondo
  ];
  devtools-go = with pkgs; [
    go
    gopls
  ];
  utility = with pkgs; [
    fish
    neovim
    curl
    git
    ghq
    delta
    difftastic
    serie
    gum
    desktop-file-utils
    rm-improved
    coreutils
    ffmpeg
    imagemagick
    hyperfine
    maestro
    tokei
    codex
    pre-commit
    manix
    devenv
    jujutsu
    # scrcpy # unsupported arm64-apple
  ];
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-older-than 3d";
  # };
  # ↑ログ出力がないため、実行結果を確認できない。launchd.agentsで直接定義する。
  launchd.agents.nix-gc = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.nix}/bin/nix-collect-garbage"
        "--delete-older-than"
        "3d"
      ];
      StartCalendarInterval = [
        {
          Hour = 0;
          Minute = 0;
          Weekday = 1; # 月曜日
        }
      ];
      StandardOutPath = "/tmp/nix-gc.log";
      StandardErrorPath = "/tmp/nix-gc.err";
    };
  };

  programs.home-manager.enable = true;

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-poi
      gh-markdown-preview
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
  home.stateVersion = "25.05";
  home.packages =
    selfPackages
    ++ programming
    ++ lsp
    ++ formatter
    ++ linter
    ++ devtools-nix
    ++ devtools-vim
    ++ devtools-web
    ++ devtools-clojure
    ++ devtools-go
    ++ utility;
}
