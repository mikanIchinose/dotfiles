{
  lib,
  stdenv,
  fetchurl,
}:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/high-moctane/mocword/releases/download/v${version}/mocword-aarch64-apple-darwin";
      hash = "sha256-35I8knOEeCyOvC35nkfg7r60Zoe7xl/abdelqTxQU68="; # hash-darwin
    };
    "x86_64-linux" = {
      url = "https://github.com/high-moctane/mocword/releases/download/v${version}/mocword-x86_64-unknown-linux-musl";
      hash = "sha256-AkNMp+SwBX/2jI2kpKMn0kfOF3phw81nwa1DsSDUN+U="; # hash-linux
    };
  };
  version = "0.2.0";
  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation {
  pname = "mocword";
  inherit version;

  src = fetchurl {
    inherit (src) url hash;
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 $src $out/bin/mocword
  '';

  meta = with lib; {
    description = "Predictive Japanese input method";
    homepage = "https://github.com/high-moctane/mocword";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "mocword";
  };
}
