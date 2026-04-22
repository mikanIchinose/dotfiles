{
  # pkgs,
  # username,
  ...
}:
{
  # 個人Mac固有の nix-darwin 設定
  homebrew.casks = [
    "brave-browser"
    "spotify"
    "google-drive"
    "zed"
    "zen"
  ];
  # homebrew.masApps = { Kindle = 302584613; };
}
