{
  lib,
  system,
  fetchFromGitHub,
  makeRustPlatform,
  fenix,
  ...
}:

let
  toolchain = fenix.minimal.toolchain;
in
(makeRustPlatform {
  cargo = toolchain;
  rustc = toolchain;
}).buildRustPackage
  rec {
    pname = "lsp-ai";
    version = "2ffc236faa1beea98e7d6ba764d9cecb21265a73";

    src = fetchFromGitHub {
      owner = "SilasMarvin";
      repo = pname;
      rev = "2ffc236faa1beea98e7d6ba764d9cecb21265a73";
      hash = "sha256-uJ4EKBLZ95Ig2dpocB/vduYXj3eKg20tXKa1KDl2DAU=";
    };

    cargoSha256 = "sha256-uYc7OD3KkQK01n6q+slBHl7RAGEt4l6cvJhi6v+Zn7A=";
    doCheck = false;

    buildFeatures = [
      "llama_cpp"
      "metal"
    ];

    meta = with lib; {
      description = "LSP-AI is an open-source language server that serves as a backend for AI-powered functionality, designed to assist and empower software engineers, not replace them.";
      homepage = "https://github.com/SilasMarvin/lsp-ai";

      license = licenses.mit;
      maintainers = [ ];
    };
  }
