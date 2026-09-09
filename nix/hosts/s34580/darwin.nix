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

  # GUI apps launched from Finder/Dock inherit launchd's minimal PATH, so tools
  # installed via Nix (gh, etc.) are invisible to them. Orca spawns `gh` without
  # an absolute path from its main process, which fails for this reason.
  launchd.user.envVariables.PATH = lib.concatStringsSep ":" [
    "/etc/profiles/per-user/s34580/bin"
    "/run/current-system/sw/bin"
    "/nix/var/nix/profiles/default/bin"
    "/opt/homebrew/bin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
  ];
}
