{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gwq";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "d-kuro";
    repo = "gwq";
    rev = "v${version}";
    hash = "sha256-lph6PybFlCZeAW81DypcZpCvC7miIWQFTRF2XM0S4tU=";
  };

  vendorHash = "sha256-XoI6tu4Giy9IMDql4VmSP74FXaVD3nizOedmfPwIRCA=";

  subPackages = [ "cmd/gwq" ];

  meta = with lib; {
    description = "Git worktree manager with fuzzy finder";
    homepage = "https://github.com/d-kuro/gwq";
    license = licenses.asl20;
    mainProgram = "gwq";
  };
}
