{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  jdk17,
}:

stdenv.mkDerivation rec {
  pname = "gradle-profiler";
  version = "0.24.0";

  src = fetchurl {
    url = "https://repo1.maven.org/maven2/org/gradle/profiler/gradle-profiler/${version}/gradle-profiler-${version}.zip";
    hash = "sha256-dPOYgqRE1tVhbTWz6Rl/dCPNJS9j8zm9PgH2Ylc7MZw=";
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/gradle-profiler $out/bin
    cp -r lib bin $out/share/gradle-profiler/

    makeWrapper $out/share/gradle-profiler/bin/gradle-profiler $out/bin/gradle-profiler \
      --set JAVA_HOME ${jdk17}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Gradle Profiler: a tool for gathering profiling and benchmarking information for Gradle builds";
    homepage = "https://github.com/gradle/gradle-profiler";
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "gradle-profiler";
  };
}
