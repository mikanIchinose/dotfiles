{
  # pkgs,
  # username,
  ...
}:
{
  # 個人Mac固有の nix-darwin 設定
  homebrew.casks = [
    "brave-browser"
    "google-chrome"
    "slack"
    "zoom"
    "spotify"
    "google-drive"
    "zed"
    "zen"
    "tailscale-app"
  ];
  # homebrew.masApps = {
  #   Keynote = 361285480;
  # };
}
