{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gwq";
  version = "0.0.18";

  src = fetchFromGitHub {
    owner = "d-kuro";
    repo = "gwq";
    rev = "v${version}";
    hash = "sha256-ZuzDKR3GYbnfhQHkQ7bfiSkSArIRXywjvSWza6OK8Vg=";
  };

  vendorHash = "sha256-4K01Xf1EXl/NVX1loQ76l1bW8QglBAQdvlZSo7J4NPI=";

  subPackages = [ "cmd/gwq" ];

  meta = with lib; {
    description = "Git worktree manager with fuzzy finder";
    homepage = "https://github.com/d-kuro/gwq";
    license = licenses.asl20;
    mainProgram = "gwq";
  };
}
