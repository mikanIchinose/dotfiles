{
  lib,
  pkgs,
  config,
  ...
}:
let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}";
  selfPackages = with pkgs; [
    gwq
    slack-reminder
    mocword
    rogcat
    covpeek
  ];
  programming = with pkgs; [
    deno
    nodejs_24 # LTS version for consistency with buildNpmPackage
    bun
    uv
  ];
  lsp = with pkgs; [
    #rust-analyzer # https://github.com/NixOS/nixpkgs/issues/432960
    yaml-language-server
    efm-langserver
    copilot-language-server
    gh-actions-language-server
  ];
  linter = with pkgs; [
    yamllint
    # actionlint
  ];
  devtools-nix = with pkgs; [
    nixd
    nixfmt
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
    # pre-commit # Swift ビルド失敗のため一時的に無効化 (nixpkgs issue)
    manix
    devenv
    jujutsu
    # scrcpy # unsupported arm64-apple

    # Go tools (from gofile)
    gogup
    vim-startuptime

    # Rust tools (from cargofile)
    cargo-cache
    cargo-make
    cargo-update
    # rogcat # aarch64-darwin not supported

    glow

    # Disk usage tools (Rust alternatives to du)
    diskus # minimal, fastest (du -sh alternative)
    dust # intuitive tree view
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
          Hour = 10;
          Minute = 30;
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
      gh-switch-issue
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

  home.sessionVariables = {
    JAVA_HOME = "/Applications/Android Studio.app/Contents/jbr/Contents/Home";
    BUN_INSTALL = "$HOME/.bun";
  };

  home.sessionPath = [
    "$HOME/dotfiles/bin"
    "$HOME/go/bin"
    "$HOME/.pub-cache/bin"
    "$HOME/.npm-global/bin"
    "$HOME/.claude/local"
    "$HOME/.fvm_flutter/bin"
    "$HOME/.local/bin"
    "$HOME/.bun/bin"
  ];

  home.file = {
    # Emacs
    ".emacs.d".source = mkLink "emacs.d";

    # Vim
    ".ideavimrc".source = mkLink "home/ideavimrc";
    ".vimrc".source = mkLink "home/vimrc";

    # Zsh
    ".zshrc".source = mkLink "home/zshrc";
    ".zshenv".source = mkLink "home/zshenv";
    ".zprofile".source = mkLink "home/zprofile";

    # Claude Code
    ".claude/settings.json".source = mkLink "claude/settings.json";
    ".claude/CLAUDE.md".source = mkLink "claude/CLAUDE.md";
    ".claude/agents".source = mkLink "claude/agents";
    ".claude/commands".source = mkLink "claude/commands";
    ".claude/hooks".source = mkLink "claude/hooks";
    ".claude/skills".source = mkLink "claude/skills";
    ".claude/statusline.sh".source = mkLink "claude/statusline.sh";
  };

  xdg.configFile = {
    "git".source = mkLink "config/git";
    "efm-langserver".source = mkLink "config/efm-langserver";
    "fish".source = mkLink "config/fish";
    "lazygit".source = mkLink "config/lazygit";
    "nvim".source = mkLink "config/nvim";
    "navi".source = mkLink "config/navi";
    "starship.toml".source = mkLink "config/starship/config.toml";
    "wezterm".source = mkLink "config/wezterm";
    "ghostty".source = mkLink "config/ghostty";
    "aerospace".source = mkLink "config/aerospace";
  }
  // (
    if pkgs.stdenv.isDarwin then
      {
        # Darwin専用
        "karabiner".source = mkLink "config.darwin/karabiner";
        "topgrade.toml".source = mkLink "config.darwin/topgrade.toml";
      }
    else
      { }
  );

  home.packages = lib.flatten [
    selfPackages
    programming
    lsp
    linter
    devtools-nix
    devtools-vim
    devtools-web
    devtools-clojure
    devtools-go
    utility
  ];
}
