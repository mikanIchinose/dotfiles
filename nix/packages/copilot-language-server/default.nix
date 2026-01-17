{
  lib,
  buildNpmPackage,
  nodejs_24,
}:

buildNpmPackage {
  pname = "copilot-language-server";
  version = "1.411.0";

  src = ./.;

  npmDepsHash = "sha256-bXwMO2l89RVDPgFu/OcCZG9P6ptp/PmglvvUtqhssLY=";

  nodejs = nodejs_24;

  dontNpmBuild = true;
  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/node_modules/@github
    cp -r node_modules/@github/copilot-language-server $out/lib/node_modules/@github/
    ln -s $out/lib/node_modules/@github/copilot-language-server/dist/language-server.js $out/bin/copilot-language-server
    chmod +x $out/bin/copilot-language-server

    runHook postInstall
  '';

  meta = with lib; {
    description = "Your AI pair programmer";
    homepage = "https://github.com/github/copilot-language-server-release";
    license = licenses.mit;
    mainProgram = "copilot-language-server";
  };
}
