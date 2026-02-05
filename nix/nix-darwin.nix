{
  self,
  pkgs,
  system,
  username,
  ...
}:
let
  homeDirectory = "/Users/${username}";
in
{
  users.users.${username}.home = homeDirectory;
  # Necessary for using flakes on this system.
  nix.enable = false;
  # nix.settings.experimental-features = "nix-command flakes";

  # M1 Mac のプラットフォーム
  nixpkgs.hostPlatform = system;

  home-manager = {
    useUserPackages = true;
    users."${username}" = {
      imports = [ ./home-manager.nix ];
      home = {
        inherit homeDirectory username;
      };
    };
    extraSpecialArgs = {
      inherit pkgs;
    };
  };

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
      cleanup = "uninstall";
    };
    brews = [
      "openssl" # need for cargo-update
      "cocoapods" # need for flutter
      "swift-format"
      "firebase-cli" # nixpkgs版はNode.js 24との互換性問題でビルド失敗 (https://github.com/NixOS/nixpkgs/issues/369813)
      "pre-commit" # nixpkgs版はSwiftビルド失敗のため一時的にHomebrewで管理
      "gradle-profiler" # nixpkgになかった
    ];
    casks = [
      "arc"
      "google-chrome"
      "ghostty"
      "jetbrains-toolbox"
      "slack"
      "karabiner-elements"
      "zoom"
      "keepassxc"
      "raycast"
      "visual-studio-code@insiders"
      "rectangle"
      "notion-calendar"
      "swiftformat-for-xcode"
      "docker-desktop"
      "spotify"
    ];
    masApps = {
      Kindle = 302584613;
      Xcode = 497799835;
    };
  };

  system.primaryUser = username;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  system.defaults.dock = {
    # ドックを自動非表示
    autohide = true;
    # 最近開いたアプリは非表示
    show-recents = false;
    # ドックの位置
    orientation = "bottom";
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
  system.defaults.NSGlobalDomain._HIHideMenuBar = false;
  # Finder
  system.defaults.finder = {
    _FXSortFoldersFirst = true;
    # 隠しファイルを表示
    AppleShowAllFiles = true;
    # 検索のスコープ: 現在のフォルダ
    FXDefaultSearchScope = "SCcf";
    # デフォルトビュー: Column View
    FXPreferredViewStyle = "clmv";
    # ファイルパスのぱんくずリストを表示
    ShowPathbar = true;
  };

  # 起動時にサウンドを再生しない
  system.startup.chime = false;

  # アプリ固有の設定
  system.defaults.CustomUserPreferences = {
    # テキスト自動補正を無効化
    NSGlobalDomain = {
      # 文頭を自動で大文字にしない
      NSAutomaticCapitalizationEnabled = false;
      # スペース2回でピリオドを挿入しない
      NSAutomaticPeriodSubstitutionEnabled = false;
      # スマート引用符（""→""）を使わない
      NSAutomaticQuoteSubstitutionEnabled = false;
      # スマートダッシュ（--→—）を使わない
      NSAutomaticDashSubstitutionEnabled = false;
      # スペルミスを自動修正しない
      NSAutomaticSpellingCorrectionEnabled = false;
    };
    # Xcode ショートカット
    "com.apple.dt.Xcode" = {
      NSUserKeyEquivalents = {
        "Editor->SwiftFormat->Format File" = "@s";
      };
    };
  };

  # Touch ID で sudo 認証
  security.pam.services.sudo_local.touchIdAuth = true;

  # darwin-rebuild 時に実行するスクリプト
  system.activationScripts.cleanDppCache.text = ''
    echo "Cleaning dpp cache..."
    rm -rf ${homeDirectory}/.cache/dpp/nvim/
  '';
}
