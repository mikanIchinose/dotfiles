{
  lib,
  buildNpmPackage,
  nodejs_24,
}:

buildNpmPackage {
  pname = "quint-language-server";
  version = "0.19.0";

  src = ./.;

  npmDepsHash = "sha256-mzfQeSvwDS/GCSAS4FJfq+K97SRlp1BBSfuPvKHSWnc=";

  nodejs = nodejs_24;

  dontNpmBuild = true;
  dontNpmInstall = true;

  # node_modules を $out/lib/node_modules に直接置くと、同じ依存 (strip-ansi 等) を持つ
  # 他の npm パッケージと home-manager の buildEnv でパス衝突するため、
  # パッケージ専用のサブディレクトリに閉じ込めて bin はラッパースクリプトにする
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/quint-language-server
    cp -r node_modules $out/lib/quint-language-server/node_modules

    cat > $out/bin/quint-language-server <<EOF
    #!/bin/sh
    exec ${lib.getExe' nodejs_24 "node"} $out/lib/quint-language-server/node_modules/@informalsystems/quint-language-server/out/src/server.js "\$@"
    EOF
    sed -i 's/^    //' $out/bin/quint-language-server
    chmod +x $out/bin/quint-language-server

    runHook postInstall
  '';

  meta = with lib; {
    description = "Language Server for the Quint specification language";
    homepage = "https://github.com/informalsystems/quint#readme";
    license = licenses.asl20;
    mainProgram = "quint-language-server";
  };
}
