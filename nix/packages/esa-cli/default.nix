{
  lib,
  buildNpmPackage,
  nodejs_24,
}:

buildNpmPackage {
  pname = "esa-cli";
  version = "0.1.1";

  src = ./.;

  npmDepsHash = "sha256-2ZLzv6smKgMkRH70sR6H0LwpiIv43OcLV1GmjKbuGDs=";

  nodejs = nodejs_24;

  dontNpmBuild = true;
  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r node_modules $out/lib/node_modules
    mkdir -p $out/bin
    ln -s $out/lib/node_modules/@esaio/esa-cli/bin/index.js $out/bin/esa
    chmod +x $out/bin/esa

    runHook postInstall
  '';

  meta = with lib; {
    description = "Official CLI for esa.io";
    homepage = "https://github.com/esaio/esa-cli#readme";
    license = licenses.mit;
    mainProgram = "esa";
  };
}
