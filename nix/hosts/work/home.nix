{
  pkgs,
  # config,
  ...
}:
{
  # 仕事Mac固有の home-manager 設定
  # 例:
  home.packages = with pkgs; [
    git-filter-repo
  ];
}
