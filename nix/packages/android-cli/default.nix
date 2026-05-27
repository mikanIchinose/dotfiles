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
      version = "1.0.15433482"; # version-darwin
      url = "https://dl.google.com/android/cli/latest/darwin_arm64/android";
      hash = "sha256-KIwoqDAj+ywjhdyfftRJfT7305ERITvNtMswqT0CQ/w="; # hash-darwin
    };
    "x86_64-linux" = {
      version = "1.0.15498356"; # version-linux
      url = "https://dl.google.com/android/cli/latest/linux_x86_64/android";
      hash = "sha256-JP87rF2xblvMX9KlTcWAQf0G2zczic1kQt7bAE/gkr4="; # hash-linux
    };
  };
  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation {
  pname = "android-cli";
  inherit (src) version;

  src = fetchurl {
    inherit (src) url hash;
  };

  dontUnpack = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glibc
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 $src $out/bin/android
  '';

  meta = with lib; {
    description = "Official Android command-line tool for creating, building, and running Android projects";
    homepage = "https://developer.android.com/";
    license = licenses.unfree;
    platforms = builtins.attrNames sources;
    mainProgram = "android";
  };
}
