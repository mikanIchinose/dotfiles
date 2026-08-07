{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jdk21_headless,
}:

stdenv.mkDerivation rec {
  pname = "cochange";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/takahirom/cochange/releases/download/${version}/cochange-${version}.tar.gz";
    hash = "sha256-miTwnW9Knb6m/U2AKXS2dxPlchv50DBJQtlvAf2zDx4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/cochange $out/bin
    cp -r lib bin $out/share/cochange/

    makeWrapper $out/share/cochange/bin/cochange $out/bin/cochange \
      --set JAVA_HOME ${jdk21_headless}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Code that changes together should live together";
    homepage = "https://github.com/takahirom/cochange";
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "cochange";
  };
}
