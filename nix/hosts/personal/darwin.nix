{
  # pkgs,
  # username,
  ...
}:
{
  # 個人Mac固有の nix-darwin 設定
  # 例:
  homebrew.casks = [
    "spotify"
    "google-drive"
  ];
  # homebrew.masApps = { Kindle = 302584613; };
}
