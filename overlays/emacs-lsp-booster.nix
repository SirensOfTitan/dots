{ lib, fetchFromGitHub, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  pname = "emacs-lsp-booster";
  version = "b98b873226b587bd1689b2073ea114d8eaa3676f";

  src = fetchFromGitHub {
    owner = "blahgeek";
    repo = pname;
    rev = "b98b873226b587bd1689b2073ea114d8eaa3676f";
    hash = "sha256-uJ4EKBLZ95Ig2dpocB/vduYXj3eKg20tXKa1KDl2DAU=";
  };

  cargoSha256 = "sha256-NJwMCThxuVXB2BeN3AGM2bQsqFAxJkeqk0w1X6ttQFQ=";
  doCheck = false;

  meta = with lib; {
    description =
      "Improve the performance of lsp-mode or eglot using a wrapper executable.";
    homepage = "https://github.com/blahgeek/emacs-lsp-booster";
    license = licenses.mit;
    maintainers = [ ];
  };
}
