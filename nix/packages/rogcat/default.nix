{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  glibc,
}:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/flxo/rogcat/releases/download/v${version}/rogcat-aarch64-apple-darwin.tar.xz";
      hash = "sha256-VqQvPuEcE6cZbBUyWHkjfL6OUBLU/hN8Cr7OU+L3Eks="; # hash-darwin
    };
    "x86_64-linux" = {
      url = "https://github.com/flxo/rogcat/releases/download/v${version}/rogcat-x86_64-unknown-linux-gnu.tar.xz";
      hash = "sha256-ZmFHtA4dH3jXQ//zNb7AOvvs9ypf6dp6Zn7ksjzapEw="; # hash-linux
    };
  };
  version = "0.5.0";
  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation {
  pname = "rogcat";
  inherit version;

  src = fetchurl {
    inherit (src) url hash;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glibc
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp rogcat $out/bin/
  '';

  meta = with lib; {
    description = "A `adb logcat` wrapper";
    homepage = "https://github.com/flxo/rogcat";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "rogcat";
  };
}
