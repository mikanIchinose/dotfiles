{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gwq";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "d-kuro";
    repo = "gwq";
    rev = "v${version}";
    hash = "sha256-eBvfMAmmpQcsl7pOcWn/yY5vnocfdusmuv7tOPvoB5s=";
  };

  vendorHash = "sha256-sUfDqBV7XNkI6TUMjAhIHnahE83YyVUCAOdvKQD9IGw=";

  subPackages = [ "cmd/gwq" ];

  meta = with lib; {
    description = "Git worktree manager with fuzzy finder";
    homepage = "https://github.com/d-kuro/gwq";
    license = licenses.asl20;
    mainProgram = "gwq";
  };
}
