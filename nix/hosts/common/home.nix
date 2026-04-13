{
  lib,
  pkgs,
  config,
  ...
}:
let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}";
  ghqLib = import ../../ghq-repos.nix { inherit lib pkgs; };
  commonGhqRepos = [
    "skk-dev/dict"
  ];
  karabinerUser = {
    name = "一瀬喜弘";
    email = "29175998+mikanIchinose@users.noreply.github.com";
  };
  selfPackages = with pkgs; [
    gwq
    slack-reminder
    mocword
    rogcat
    covpeek
    gradle-profiler
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
    vim-startuptime
    vim-language-server
    lua-language-server
    stylua
    luajitPackages.luacheck
    tree-sitter
  ];
  devtools-web = with pkgs; [
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
  devtools-flutter = with pkgs; [
    fvm # version manager
    cocoapods # need for flutter
    flutterfire-cli # integrate firebase
  ];
  devtools-android = with pkgs; [
    android-cli
  ];
  devtools-swift = with pkgs; [
    swift-format
  ];
  utility = with pkgs; [
    fish
    neovim
    curl
    git
    ghq
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
    tmux
    glow
    ghostscript # pdf圧縮用
    google-cloud-sdk # gcloud cli
    firebase-tools
    pre-commit

    # ai-tools
    llm-agents.codex
    llm-agents.claude-code
    manix
    # scrcpy # unsupported arm64-apple

    # Disk usage tools (Rust alternatives to du)
    diskus # minimal, fastest (du -sh alternative)
    dust # intuitive tree view
  ];
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

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

  home.activation = ghqLib.mkGhqActivation "common" commonGhqRepos;

  programs.home-manager.enable = true;

  programs.nix-index-database.comma.enable = true;
  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-poi
      gh-markdown-preview
      gh-switch-issue
    ];
    gitCredentialHelper = {
      enable = true;
    };
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
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      whitelist.prefix = [ "${config.home.homeDirectory}/ghq/github.com/mikanIchinose" ];
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
    options = {
      features = "line-numbers decorations";
      whitespace-error-style = "22 reverse";
      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow ul";
        file-decoration-style = "none";
      };
      no-line-number.line-numbers = false;
    };
  };
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = config.programs.git.settings.user.name;
        email = config.programs.git.settings.user.email;
      };
      ui = {
        editor = config.programs.git.settings.core.editor;
        diff-editor = ":builtin";
        default-command = "log";
      };
      "remotes.origin" = {
        auto-track-bookmarks = "*";
      };
      "--scope" = [
        {
          "--when".repositories = [ "~/ghq-karabiner" ];
          user = karabinerUser;
        }
      ];
    };
  };
  programs.git = {
    enable = true;
    ignores = [
      "**/.claude/settings.local.json"
    ];
    includes = [
      {
        condition = "gitdir:~/ghq-karabiner/";
        contents = {
          user = karabinerUser;
        };
      }
    ];
    settings = {
      # ユーザー情報
      user = {
        name = "mikanIchinose";
        email = "29175998+mikanIchinose@users.noreply.github.com";
      };

      # コア設定
      core = {
        editor = "nvim";
        autocrlf = "input";
        whitespace = "trailing-space";
        quotepath = false;
      };
      init.defaultBranch = "main";

      # エイリアス
      alias = {
        pushf = "push --force-with-lease --force-if-includes";
        start = "commit --allow-empty --no-verify --message \"対応開始\"";
        aicommit = "!f() { COMMITMSG=$(claude -p 'Generate ONLY a one-line Git commit message in Japanese, using imperative mood, summarizing what was changed and why, based strictly on the contents of `git diff --cached`. Do not add explanation or a body. Output only the commit summary line.'); git commit -m \"$COMMITMSG\" -e; }; f";
      };

      # リモート操作
      push = {
        default = "current";
        autoSetupRemote = true;
        userForceIfIncludes = true;
      };
      pull = {
        rebase = true;
        ff = "only";
      };
      fetch.prune = true;
      rebase = {
        autosquash = true;
        autostash = true;
      };

      # マージ
      merge.tool = "vimdiff";
      mergetool.keepBackup = false;

      # コミット
      commit.template = "~/.config/git/message";

      # 表示設定
      status.showUntrackedFiles = "all";
      advice.addIgnoreFile = false;
      color = {
        ui = true;
      };
      "color \"status\"" = {
        added = "green";
        changed = "red";
        untracked = "yellow";
        unmerged = "magenta";
      };

      # 差分ツール
      difftool.prompt = false;
      "difftool \"nvimdiff\"".cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
      "difftool \"difftatic\"".cmd = "difft \"$LOCAL\" \"$REMOTE\"";

      # 認証
      credential.helper = "osxkeychain";

      # ghq
      ghq = {
        root = "~/ghq";
        "https://github.com/karabiner-inc".root = "~/ghq-karabiner";
        "https://kara.git.backlog.jp".root = "~/ghq-karabiner";
        "https://gitlab.digitalatelier.info".root = "~/ghq-karabiner";
        "https://github.com/Oisix".root = "~/ghq-karabiner";
      };
    };
  };

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
    ".claude/rules".source = mkLink "claude/rules";
    ".claude/statusline.sh".source = mkLink "claude/statusline.sh";
    ".claude/lessons-learned.md".source = mkLink "claude/lessons-learned.md";
  };

  xdg.configFile = {
    "git/message".source = mkLink "config/git/message";
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
    devtools-flutter
    devtools-android
    devtools-swift
    utility
  ];
}
