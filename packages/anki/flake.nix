{
  description = "A spaced repetition software.";

  inputs = {
    nixpkgs.follows = "nix/nixpkgs";
    anki = {
      url = "github:ankitects/anki";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, anki }:
    let
      version = "2.1.50";
      supportedSystems = [
        "x86_64-linux"
        "i686-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
      {
        overlay = final: prev: {
          anki = with final; let nix = final.nix; in buildPythonApplication rec {
            src = anki;
            propagatedBuildInputs = [
              pyqtwebengine
              sqlalchemy
              beautifulsoup4
              send2trash
              pyaudio
              requests
              decorator
              markdown
              jsonschema
              setuptools
              matplotlib
            ]
            ++ nixpkgs.lib.optional nixpkgs.stdenv.isDarwin [ CoreAudio ];
            checkInputs = [ pytest glibcLocales nose ];
            nativeBuildInputs = [ pyqtwebengine.wrapQtAppsHook ];
            patches = [
              ./no-version-check.patch
            ];

            dontBuild = true;

            postPatch = ''
              # Remove QT translation files. We'll use the standard QT ones.
              rm "locale/"*.qm
              # hitting F1 should open the local manual
              substituteInPlace anki/consts.py \
                --replace 'HELP_SITE="http://ankisrs.net/docs/manual.html"' \
                          'HELP_SITE="${manual}/share/doc/anki/html/manual.html"'
            '';

            LC_ALL = "en_US.UTF-8";

            doCheck = !nixpkgs.stdenv.isDarwin;
            checkPhase = ''
              HOME=$TMP pytest --ignore tests/test_sync.py
            '';
          };
        };
      };
}
