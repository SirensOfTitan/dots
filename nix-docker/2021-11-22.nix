{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nixpkgs-21.11pre333180.98747f27ecf";
  version = "2021-11-22";

  src = fetchurl {
    url = "https://releases.nixos.org/nixpkgs/${name}/nixexprs.tar.xz";
    sha256 = "5ab026fb9b674875280a3dc830a23317d5db0c6b5871ed3816436ce50e7eba30";
  };

  dontBuild = true;
  preferLocalBuild = true;

  installPhase = ''
    cp -a . $out
  '';
}
