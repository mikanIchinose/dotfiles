{
  lib,
  buildNpmPackage,
  nodejs_24,
}:

buildNpmPackage {
  pname = "copilot-language-server";
  version = "1.548.0";

  src = ./.;

  npmDepsHash = "sha256-he6Os3rUsEepLpWT2Eq71XWqkVzb2Ke8jj1U3HKS1ps=";

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
