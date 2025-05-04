{
  self,
  system,
  pkgs,
  ...
}:
{
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  # M1 Mac のプラットフォーム
  nixpkgs.hostPlatform = system;

  fonts = {
    packages = with pkgs; [
      udev-gothic-nf
      plemoljp-nf
    ];
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    brews = [
      "openssl" # need for cargo-update
      "fvm"
      "cocoapods" # need for flutter
      "bitwarden-cli"
      "arbigent"
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
      "notion"
      "notion-calendar"
      "figma"
      "visual-studio-code@insiders"
      "docker" # need for dagger
      "logseq"
      "google-chrome" # need for flutter
      "claude"
      "obsidian"
      "macskk"
      "aerospace"
    ];
    masApps = {
      TogglTrack = 1291898086;
      Kindle = 302584613;
      "Save to Raindrop.io" = 1549370672;
      Xcode = 497799835;
      Bitwarden = 1352778147;
      ToyViewer = 414298354;
    };
  };

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

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

  # 起動時にサウンドを再生しない
  system.startup.chime = false;

  # background task
  # launchd.agents.sample = {
  #   serviceConfig = {
  #     UserName = "mikan";
  #     SessionCreate = true;
  #     ProgramArguments = [
  #       "/Users/mikan/local/scripts/sample"
  #     ];
  #     ProcessType = "Background";
  #     StartInterval = 60;
  #     StandardOutPath = "/tmp/sample.log";
  #     StandardErrorPath = "/tmp/sample.log";
  #   };
  # };
  # launchd.agents.auto-save-note = {
  #   serviceConfig = {
  #     UserName = "mikan";
  #     SessionCreate = true;
  #     ProgramArguments = [
  #       "/Users/mikan/local/scripts/auto-save-note"
  #     ];
  #     ProcessType = "Background";
  #     StartInterval = 60;
  #     StartCalendarInterval = [
  #       { Hour = 10; }
  #       { Hour = 15; }
  #       { Hour = 20; }
  #     ];
  #     StandardOutPath = "/tmp/update-note.log";
  #     StandardErrorPath = "/tmp/update-note.err.log";
  #   };
  # };
  # launchd.agents.backup-to-sd-card = {
  #   serviceConfig = {
  #     UserName = "mikan";
  #     ProgramArguments = [
  #       "/Users/mikan/local/scripts/backup-to-sd-card"
  #     ];
  #     ProcessType = "Background";
  #     StartCalendarInterval = [
  #       {
  #         Day = 1;
  #         Hour = 13;
  #       }
  #       {
  #         Day = 1;
  #         Hour = 14;
  #       }
  #       {
  #         Day = 1;
  #         Hour = 15;
  #       }
  #     ];
  #     StandardOutPath = "/tmp/backup-to-sd-card.log";
  #     StandardErrorPath = "/tmp/backup-to-sd-card.err.log";
  #   };
  # };
}
