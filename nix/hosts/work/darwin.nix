{
  # pkgs,
  # username,
  ...
}:
{
  # 仕事Mac固有の nix-darwin 設定
  # 例:
  # homebrew.brews = [ "cocoapods" ];
  homebrew.casks = [
    "slack"
    "zoom"
    "notion-calendar"
  ];
}
