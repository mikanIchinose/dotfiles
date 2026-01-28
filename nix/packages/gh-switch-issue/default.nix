{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  gum,
  git,
  gawk,
}:

stdenv.mkDerivation rec {
  pname = "gh-switch-issue";
  version = "unstable-2024-03-10";

  src = fetchFromGitHub {
    owner = "mikanIchinose";
    repo = "gh-switch-issue";
    rev = "181829fac5070e4dec0571b959384daa96bd959e";
    hash = "sha256-wwc6XVR/KhxsqztlW0FpvbXoDXQMX6H3ZDejD2O0CFQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 gh-switch-issue $out/bin/gh-switch-issue
    wrapProgram $out/bin/gh-switch-issue \
      --prefix PATH : ${
        lib.makeBinPath [
          gum
          git
          gawk
        ]
      }
    runHook postInstall
  '';

  meta = with lib; {
    description = "GitHub CLI extension to switch to issue branches";
    homepage = "https://github.com/mikanIchinose/gh-switch-issue";
    license = licenses.mit;
    mainProgram = "gh-switch-issue";
  };
}
