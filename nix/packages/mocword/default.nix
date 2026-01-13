{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "mocword";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/high-moctane/mocword/releases/download/v${version}/mocword-aarch64-apple-darwin";
    hash = "sha256-35I8knOEeCyOvC35nkfg7r60Zoe7xl/abdelqTxQU68=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/mocword
    chmod +x $out/bin/mocword
  '';

  meta = with lib; {
    description = "Predictive Japanese input method";
    homepage = "https://github.com/high-moctane/mocword";
    license = licenses.mit;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "mocword";
  };
}
