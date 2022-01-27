{ stdenv, fetchurl, undmg, lib }:

let version = "97.0b8";
in
stdenv.mkDerivation rec {
  pname = "firefox-dev-edition";
  inherit version;

  src = fetchurl {
    name = "firefox-dev-edition-${version}.dmg";
    url = "https://download-installer.cdn.mozilla.net/pub/devedition/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
    sha256 = "1e936aa7b761cb3f91a23fd11d46aab926c4dba84612b28b02c2375e67591f66";
  };

  buildInputs = [ undmg ];
  sourceRoot = ".";

  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -a "Firefox Developer Edition.app" "$out/Applications"
  '';

  meta = with lib; {
    description = "The firefox web browser for developers.";
    homepage = "https://www.mozilla.org/en-US/firefox/developer/";
    maintainers = [ maintainers.colep ];
    platforms = platforms.darwin;
  };
}
