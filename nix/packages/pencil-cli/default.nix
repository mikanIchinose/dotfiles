{
  lib,
  buildNpmPackage,
  nodejs_24,
  makeWrapper,
}:

buildNpmPackage {
  pname = "pencil-cli";
  version = "0.2.9";

  src = ./.;

  npmDepsHash = "sha256-g2i0Ijj1pWGFEiO1HC0Xb9Fg7kY7IAgHie3RI0y45WQ=";

  nodejs = nodejs_24;

  dontNpmBuild = true;
  dontNpmInstall = true;

  nativeBuildInputs = [ makeWrapper ];

  # pencil は ESM アプリで実行時に node_modules の依存を import するため、
  # CLI 本体だけでなく node_modules ツリー全体を同梱し node で起動する。
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pencil-cli
    cp -r node_modules $out/lib/pencil-cli/

    makeWrapper ${nodejs_24}/bin/node $out/bin/pencil \
      --add-flags $out/lib/pencil-cli/node_modules/@pencil.dev/cli/dist/index.mjs

    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI tool for running the Pencil AI agent manipulating .pen design files";
    homepage = "https://www.npmjs.com/package/@pencil.dev/cli";
    license = licenses.unfree; # UNLICENSED (proprietary)
    mainProgram = "pencil";
  };
}
