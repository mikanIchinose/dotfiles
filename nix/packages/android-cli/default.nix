{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  glibc,
}:

let
  version = "0.7.15232955";
  sources = {
    "aarch64-darwin" = {
      url = "https://edgedl.me.gvt1.com/edgedl/android/cli/latest/darwin_arm64/android";
      hash = "sha256-N70ts4oIEp2vYzxPqnqi30lW/+UUGT/bucO6nHs8jUY="; # hash-darwin
    };
    "x86_64-linux" = {
      url = "https://edgedl.me.gvt1.com/edgedl/android/cli/latest/linux_x86_64/android";
      hash = "sha256-y4woDP/5fqc6C6U50jXaOqiDBZzzENZSbHUCTt2zKic="; # hash-linux
    };
  };
  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation {
  pname = "android-cli";
  inherit version;

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
