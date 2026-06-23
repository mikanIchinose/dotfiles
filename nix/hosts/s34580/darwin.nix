{ lib, ... }:
{
  # Slack and Chrome are managed by the company, so do not let `brew bundle`
  # cleanup uninstall casks that are installed outside this configuration.
  homebrew.onActivation = {
    cleanup = lib.mkForce "none";
    extraFlags = lib.mkForce [ ];
  };

  homebrew.brews = [
    "mint"
  ];
  homebrew.casks = [
    "cloudflare-warp"
  ];
}
