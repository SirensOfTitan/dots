{
  description = "An emacs build for mac.";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.follows = "nixpkgs";
    emacs-mac = {
      flake = false;
      url = "git+https://bitbucket.org/mituharu/emacs-mac.git?work";
    };
  };

  outputs = { self, flake-utils, nixpkgs, emacs-mac }:
    flake-utils.lib.eachDefaultSystem(system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packageName = "emacs-mac";
      in {
        packages.${packageName} = pkgs.stdenv.mkDerivation {
          pname = "emacs-mac";
          version = substring 0 7 emacs-mac.rev;

          src = emacs-mac;

          enableParallelBuilding = true;

          nativeBuildInputs = with pkgs; [
            autoconf
            automake
            pkg-config
            makeWrapper
          ];

          buildInputs = with pkgs; [
            gconf
            libxml2
            jansson
            imagemagick
            librsvg
            texinfo
            libgccjit
            sigtool
            sqlite
            gnutls
          ];

          configureFlags = [
            # for a more reproducible build
            "--disable-build-details"
            "--with-modules"
            "--with-mac"
            "--with-gnutls"
            "--with-mac-metal"
            "--with-rsvg"
            "--with-native-compilation"
          ]
        };

        defaultPackage = self.packages.${system}.${packageName};
      }
    )
}
