{
  description = "mikan m1 mac-book-pro nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      rust-overlay,
      neovim-nightly-overlay,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.curl
            pkgs.git
            pkgs.gh
            pkgs.ghq
            pkgs.delta
            pkgs.go
            pkgs.fish
            pkgs.deno
            pkgs.starship
            pkgs.lazygit
            pkgs.ripgrep
            pkgs.ripgrep-all
            pkgs.fd
            pkgs.eza
            pkgs.zoxide
            pkgs.bat
            pkgs.gum
            pkgs.scrcpy
            pkgs.desktop-file-utils
            pkgs.rm-improved
            pkgs.yazi
            pkgs.nodejs
            pkgs.fzf
            pkgs.coreutils
            pkgs.nixd
            pkgs.nixfmt-rfc-style
            pkgs.serie
            neovim-nightly-overlay.packages.${pkgs.system}.default
          ];

          homebrew = {
            enable = true;
            onActivation = {
              autoUpdate = true;
              upgrade = true;
              cleanup = "uninstall";
            };
            brews = [
              "openssl" # need for cargo-update
            ];
            casks = [
              "arc"
              "wezterm"
              "jetbrains-toolbox"
              "slack"
              "karabiner-elements"
              "zoom"
              "keepassxc"
              "raycast"
              "rectangle"
              "notion"
              "notion-calendar"
              "figma"
              "visual-studio-code"
              "docker" # need for dagger
              "logseq"
            ];
            masApps = {
              "Toggl Track" = 1291898086;
            };
          };

          # make GUI apps findable to spotlight
          #system.activationScripts.applications.text = let
          #  env = pkgs.buildEnv {
          #    name = "system-applications";
          #    paths = config.environment.systemPackages;
          #    pathsToLink = "/Applications";
          #  };
          #in
          #  pkgs.lib.mkForce ''
          #    echo "setting up ~/Applications/Nix..."
          #    rm -rf /Applications/Nix\ Apps
          #    mkdir -p /Applications/Nix\ Apps
          #    find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          #    while read -r src; do
          #      app_name=$(basename "$src")
          #      ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          #    done
          #  '';

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # M1 Mac のプラットフォーム
          nixpkgs.hostPlatform = "aarch64-darwin";

          system.defaults.dock = {
            # ドックを自動非表示
            autohide = true;
            # 最近開いたアプリは非表示
            show-recents = false;
            # ドックの位置
            orientation = "bottom";
            persistent-apps = [
              "/System/Applications/Launchpad.app"
            ];
            tilesize = 30;
          };
          # ライトモード/ダークモードを自動で切り替える
          system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
          # 初回を小さくしすぎると誤入力のもとになる
          system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
          # キーを押しっぱなしにしたあとの入力速度は高速にする
          system.defaults.NSGlobalDomain.KeyRepeat = 1;
          # alert volume
          system.defaults.NSGlobalDomain."com.apple.sound.beep.volume" = 0.6065307;
          # メニューバーを自動で非表示にする
          system.defaults.NSGlobalDomain._HIHideMenuBar = true;
          # 起動時にサウンドを再生しない
          system.startup.chime = false;
          # Finder
          system.defaults.finder = {
            _FXSortFoldersFirst = true;
            # 隠しファイルは非表示
            AppleShowAllFiles = false;
            # 検索のスコープ: 現在のフォルダ
            FXDefaultSearchScope = "SCcf";
            # デフォルトビュー: Column View
            FXPreferredViewStyle = "clmv";
            # ファイルパスのぱんくずリストを表示
            ShowPathbar = true;
          };
          # background task
          launchd.agents.auto-save-note = {
            serviceConfig = {
              ProgramArguments = [
                "/run/current-system/sw/bin/zsh"
                "/Users/mikan/local/scripts/auto-save-note"
              ];
              ProcessType = "Background";
              StartCalendarInterval = [ { Minute = 0; } ]; # hourly
              StandardOutPath = "/tmp/update-note.log";
              StandardErrorPath = "/tmp/update-note.err.log";
            };
          };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#mikan
      darwinConfigurations."mikan" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "mikan";
              autoMigrate = true;
            };
          }
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = [ rust-overlay.overlays.default ];
              environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
            }
          )
        ];
      };
    };
}
