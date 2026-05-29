{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "covpeek";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Chapati-Systems";
    repo = "covpeek";
    rev = "v${version}";
    hash = "sha256-dfxqqxoZqrN8065POXGlJ81WokBpg03ob+swZF6wxbs=";
  };

  vendorHash = "sha256-lVHqHQWyDRNk7WNULZ1WFjfzVPRAtNdtLibiSCHNjTc=";

  meta = with lib; {
    description = "Cross-language Coverage Report CLI Parser in Go";
    homepage = "https://github.com/Chapati-Systems/covpeek";
    license = licenses.agpl3Only;
    mainProgram = "covpeek";
  };
}
