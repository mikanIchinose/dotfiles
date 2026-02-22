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
    taps = [
      "manaflow-ai/cmux"
    ];
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
      "wezterm"
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
      "claude"
      "cmux"
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
  # system.activationScripts はinternal = trueのため、extraActivation に統合して組み込む
  system.activationScripts.extraActivation.text = ''
    echo "Cleaning dpp cache..."
    rm -rf ${homeDirectory}/.cache/dpp/nvim/

    # ウィンドウタイリング キーボードショートカット
    # parameters: (char_code, key_code, modifier_flags)
    # modifier_flags: Ctrl=262144, Opt=524288, Fn=8388608, Ctrl+Opt+Fn=9175040, Ctrl+Opt=786432
    echo >&2 "Setting up window tiling keyboard shortcuts..."
    PLIST="${homeDirectory}/Library/Preferences/com.apple.symbolichotkeys.plist"

    set_hotkey() {
      local id="$1" char="$2" keycode="$3" mod="$4"
      local json="{\"enabled\":true,\"value\":{\"parameters\":[$char,$keycode,$mod],\"type\":\"standard\"}}"
      launchctl asuser "$(id -u -- ${username})" sudo --user=${username} -- \
        plutil -replace "AppleSymbolicHotKeys.$id" -json "$json" "$PLIST" 2>/dev/null || \
      launchctl asuser "$(id -u -- ${username})" sudo --user=${username} -- \
        plutil -insert "AppleSymbolicHotKeys.$id" -json "$json" "$PLIST"
    }

    # 半画面配置 (Ctrl+Opt+矢印)
    set_hotkey 240 65535 123 9175040  # ← Left Half
    set_hotkey 241 65535 124 9175040  # → Right Half
    set_hotkey 242 65535 126 9175040  # ↑ Top Half
    set_hotkey 243 65535 125 9175040  # ↓ Bottom Half
    # 4分の1画面配置 (Ctrl+Opt+U/I/J/K)
    set_hotkey 244 117 32 786432  # U: Top-Left
    set_hotkey 245 105 34 786432  # I: Top-Right
    set_hotkey 246 106 38 786432  # J: Bottom-Left
    set_hotkey 247 107 40 786432  # K: Bottom-Right

    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u || true
  '';
}
