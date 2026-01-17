{
  lib,
  buildNpmPackage,
  nodejs_24,
}:

buildNpmPackage {
  pname = "gh-actions-language-server";
  version = "0.0.3";

  src = ./.;

  npmDepsHash = "sha256-qG6CoC1ubaH/Y5/Dbxa9cRoWb0PYCKnnHK23zTCI/rc=";

  nodejs = nodejs_24;

  dontNpmBuild = true;
  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/node_modules
    cp -r node_modules/gh-actions-language-server $out/lib/node_modules/
    ln -s $out/lib/node_modules/gh-actions-language-server/bin/gh-actions-language-server $out/bin/gh-actions-language-server

    runHook postInstall
  '';

  meta = with lib; {
    description = "GitHub Actions Language Server";
    homepage = "https://github.com/actions/languageservices";
    license = licenses.mit;
    mainProgram = "gh-actions-language-server";
  };
}
