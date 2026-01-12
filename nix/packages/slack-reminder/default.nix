{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "slack-reminder";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "skanehira";
    repo = "slack-reminder";
    rev = "v${version}";
    hash = "sha256-1MzRZ8E1wtwThnaXteMkAapX5kLFbEi3ix1csatSFF8=";
  };

  vendorHash = "sha256-WTP2iEwffesoS0mSfqPOVZycoyJAs/nTPR0AlIkDyYo=";

  meta = with lib; {
    description = "Create and list Slack reminders from CLI";
    homepage = "https://github.com/skanehira/slack-reminder";
    license = licenses.mit;
    mainProgram = "slack-reminder";
  };
}
