{
  lib,
  darwin,
  fetchFromGitHub,
  makeRustPlatform,
  fenix,
  ...
}:

let
  toolchain = fenix.stable.toolchain;
  platform = makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
  rev = "cd46ecf61adc272491c25c4faf4b5f9d92c3d4a6";
in
platform.buildRustPackage {
  pname = "lsp-ai";
  version = rev;

  src = fetchFromGitHub {
    inherit rev;
    owner = "SilasMarvin";
    repo = "lsp-ai";
    sha256 = "sha256-64ojWs9YrQiCv5u+z/hxTOMz/bPOKt9/tzj7nHW4WCw=";
  };

  buildInputs = with darwin.apple_sdk.frameworks; [
    SystemConfiguration
    MetalPerformanceShaders
    MetalKit
    Metal
  ];

  cargoLock =
    let
      fixupLockFile = path: builtins.readFile path;
    in
    {
      lockFileContents = fixupLockFile ./Cargo.lock;
      outputHashes = {
        # Add below hf-hub 0.3.3:
        "hf-hub-0.3.2" = "sha256-1AcishEVkTzO3bU0/cVBI2hiCFoQrrPduQ1diMHuEwo=";
      };
    };
  patches = [ ./lsp-ai-cargo-lock.diff ];
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
