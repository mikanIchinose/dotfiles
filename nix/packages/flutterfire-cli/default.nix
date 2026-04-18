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
    hash = "sha256-wQAfjsiLRIH5SOz4tWHFJejYsJtJKfa2hltzeTnVx84=";
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
