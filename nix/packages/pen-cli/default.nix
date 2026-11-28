{
  lib,
  buildNpmPackage,
  nodejs_24,
  makeWrapper,
}:

buildNpmPackage {
  pname = "pen-cli";
  version = "0.3.19";

  src = ./.;

  npmDepsHash = "sha256-+SUkuzKowHWHKo7MZ646skPDJ3B30KbjmUFrZpLh/Qw=";

  nodejs = nodejs_24;

  dontNpmBuild = true;
  dontNpmInstall = true;

  nativeBuildInputs = [ makeWrapper ];

  # pen は ESM アプリで実行時に node_modules の依存を import するため、
  # CLI 本体だけでなく node_modules ツリー全体を同梱し node で起動する。
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pen-cli
    cp -r node_modules $out/lib/pen-cli/

    makeWrapper ${nodejs_24}/bin/node $out/bin/pen \
      --add-flags $out/lib/pen-cli/node_modules/@pen.dev/cli/dist/index.mjs
    ln -s $out/bin/pen $out/bin/pencil

    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI tool for creating and editing .pen design files (formerly Pencil CLI)";
    homepage = "https://www.npmjs.com/package/@pen.dev/cli";
    license = licenses.unfree; # UNLICENSED (proprietary)
    mainProgram = "pen";
  };
}
