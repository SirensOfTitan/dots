{ stdenv, fetchurl, undmg, lib }:

let version = "97.0b6";
in
stdenv.mkDerivation rec {
  pname = "firefox-dev-edition";
  inherit version;

  src = fetchurl {
    name = "firefox-dev-edition-${version}.dmg";
    url = "https://download-installer.cdn.mozilla.net/pub/devedition/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
    sha256 = "36a1d409f4ce3385a81e59fe637cbd1aebab4d11676aefd153807e9c1c85c1bc";
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
