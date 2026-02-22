{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "rogcat";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/flxo/rogcat/releases/download/v${version}/rogcat-aarch64-apple-darwin.tar.xz";
    hash = "sha256-VqQvPuEcE6cZbBUyWHkjfL6OUBLU/hN8Cr7OU+L3Eks=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp rogcat $out/bin/
  '';

  meta = with lib; {
    description = "A `adb logcat` wrapper";
    homepage = "https://github.com/flxo/rogcat";
    license = licenses.mit;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "rogcat";
  };
}
