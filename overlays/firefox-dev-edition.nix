{ stdenv, fetchurl, undmg, lib }:

let version = "99.0b2";
in stdenv.mkDerivation rec {
  pname = "firefox-dev-edition";
  inherit version;

  src = fetchurl {
    name = "firefox-dev-edition-${version}.dmg";
    url =
      "https://download-installer.cdn.mozilla.net/pub/devedition/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
    sha256 = "sha256-0fuIkXhfJQnwIPjlel99VUh3SAwDtU4Z1PJ15Q2Q1I0=";
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
