{
  self,
  pkgs,
  system,
  ...
}:
{
  # Necessary for using flakes on this system.
  nix.enable = false;
  # nix.settings.experimental-features = "nix-command flakes";

  # M1 Mac のプラットフォーム
  nixpkgs.hostPlatform = system;

  fonts = {
    packages = with pkgs; [
      udev-gothic-nf
      plemoljp-nf
    ];
  };

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  system.primaryUser = "mikan";

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
}
