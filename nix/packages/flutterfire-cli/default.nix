{
  lib,
  buildDartApplication,
  fetchFromGitHub,
}:

buildDartApplication rec {
  pname = "flutterfire-cli";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "invertase";
    repo = "flutterfire_cli";
    tag = "flutterfire_cli-v${version}";
    hash = "sha256-6ifQG4C3LbCiJhYyseJUqutRuWX8xsfAosSkhsF1fQM=";
  };

  sourceRoot = "${src.name}/packages/flutterfire_cli";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  meta = with lib; {
    description = "A CLI to help with using FlutterFire in your Flutter applications.";
    homepage = "https://github.com/invertase/flutterfire_cli";
    license = licenses.asl20;
    mainProgram = "flutterfire";
  };
}
