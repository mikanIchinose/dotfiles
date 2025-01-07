{
  description = "mikan m1 mac-book-pro nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, rust-overlay }:
  let
    configuration = { pkgs, config, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.neovim
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
          #"google-japanese-ime"
          #"google-drive"
        ];
        masApps = {
          "Toggl Track" =1291898086;
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

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      system.defaults = {
        dock = {
          # ドックを自動非表示
          autohide = true;
          # 最近開いたアプリは非表示
          show-recents = false;
        };
        NSGlobalDomain = {
          # ライトモード/ダークモードを自動で切り替える
          AppleInterfaceStyleSwitchesAutomatically = true;
          # AppleInterfaceStyle= null;
          # 初回を小さくしすぎると誤入力のもとになる
          InitialKeyRepeat = 10;
          # キーを押しっぱなしにしたあとの入力速度は高速にする
          KeyRepeat = 1;
        };
      };
      # 起動時にサウンドを再生しない
      system.startup.chime = false;
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
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ rust-overlay.overlays.default ];
          environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
        })
      ];
    };
  };
}
