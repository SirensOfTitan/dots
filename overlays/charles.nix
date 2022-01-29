{ lib, stdenv, fetchurl, undmg, ... }:

let version = "4.6.2";
in stdenv.mkDerivation rec {
  pname = "charles";
  inherit version;

  src = fetchurl {
    url =
      "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}.dmg";
    sha256 = "sha256-jmbHPr1dl7vit54nvf0/Bime23+UEkbqUswyiDkX3xI=";
  };

  buildInputs = [ undmg ];
  sourceRoot = ".";

  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -a "Charles.app" "$out/Applications"
  '';

  meta = with lib; {
    description = "Web debugging proxy";
    homepage = "https://www.charlesproxy.com/";
    maintainers = with maintainers; [ colep ];
    license = licenses.unfree;
    platforms = platforms.darwin;
  };
}
