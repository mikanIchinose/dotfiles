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

  # M1 Mac のプラットフォーム
  nixpkgs.hostPlatform = system;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "android-cli" ];

  home-manager = {
    useUserPackages = true;
    users."${username}" = {
      imports = [ ./home.nix ];
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

  environment.systemPackages = with pkgs; [
    xcodes
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
      # Homebrew 5.1+ で `brew bundle --cleanup` に確認プロンプトが追加され、
      # 非対話実行には --force-cleanup 等が必須になったため付与する
      extraFlags = [ "--force-cleanup" ];
    };
    taps = [
      "arto-app/tap"
      "jetbrains/utils"
    ];
    brews = [
      "kotlin-lsp"
      "poppler"
    ];
    casks = [
      "wezterm"
      "jetbrains-toolbox"
      "karabiner-elements"
      "visual-studio-code@insiders"
      "swiftformat-for-xcode"
      "docker-desktop"
      "claude"
      "codex-app"
      "rectangle"
      "notion-calendar"
      "arto"
    ];
    # masApps = {
    #   Kindle = 302584613;
    #   Xcode = 497799835;
    #   Bitwarden = 1352778147;
    # };
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
    # 固定アプリを表示しない
    persistent-apps = [ ];
    # 起動中のアプリのみ表示する（固定・最近使ったアプリを出さない）
    static-only = true;
    # Dock の出し入れアニメーションを高速化
    autohide-time-modifier = 0.2;
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
  # テキスト自動補正を無効化
  # 文頭を自動で大文字にしない
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  # スペース2回でピリオドを挿入しない
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  # スマート引用符（""→""）を使わない
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  # スマートダッシュ（--→—）を使わない
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  # スペルミスを自動修正しない
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
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
    # ゴミ箱の30日経過アイテムを自動削除
    FXRemoveOldTrashItems = true;
  };

  # スクリーンショット撮影後の右下サムネイルを表示せず即保存する
  system.defaults.screencapture.show-thumbnail = false;

  # バッテリー残量をパーセント表示
  system.defaults.controlcenter.BatteryShowPercentage = true;
  # 壁紙クリックでデスクトップ表示を無効化（誤操作防止）
  system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;
  # メニューバー時計を24時間表示
  system.defaults.menuExtraClock.Show24Hour = true;

  # 起動時にサウンドを再生しない
  system.startup.chime = false;

  # アプリ固有の設定
  system.defaults.CustomUserPreferences = {
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
  # system.activationScripts はinternal = trueのため、extraActivation に統合して組み込む
  system.activationScripts.extraActivation.text = ''
    echo "Cleaning dpp cache..."
    rm -rf ${homeDirectory}/.cache/dpp/nvim/
  '';
}
