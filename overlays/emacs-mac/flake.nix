{
  description = "An emacs build for mac.";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    emacs-mac = {
      flake = false;
      url = "git+https://bitbucket.org/mituharu/emacs-mac.git?ref=work";
    };
  };

  outputs = { self, flake-utils, nixpkgs, emacs-mac, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        stdenv = pkgs.gccStdenv;
        packageName = "emacs-mac";
        emacsVersion = "28.0.91";
        localVersion = "4";
      in {
        packages.${packageName} = stdenv.mkDerivation {
          pname = "emacs-mac";
          version = "${emacsVersion}-${
              builtins.substring 0 4 emacs-mac.rev
            }-${localVersion}";

          src = emacs-mac;

          meta = with nixpkgs.lib; {
            description = "The extensible, customizable text editor";
            homepage = "https://www.gnu.org/software/emacs/";
            license = licenses.gpl3Plus;
            maintainers = with maintainers; [ colep ];
            platforms = platforms.darwin;

            longDescription = ''
              GNU Emacs is an extensible, customizable text editor—and more.  At its
              core is an interpreter for Emacs Lisp, a dialect of the Lisp
              programming language with extensions to support text editing.
              The features of GNU Emacs include: content-sensitive editing modes,
              including syntax coloring, for a wide variety of file types including
              plain text, source code, and HTML; complete built-in documentation,
              including a tutorial for new users; full Unicode support for nearly all
              human languages and their scripts; highly customizable, using Emacs
              Lisp code or a graphical interface; a large number of extensions that
              add other functionality, including a project planner, mail and news
              reader, debugger interface, calendar, and more.  Many of these
              extensions are distributed with GNU Emacs; others are available
              separately.
              This is the "Mac port" addition to GNU Emacs 26. This provides a native
              GUI support for Mac OS X 10.6 - 10.12. Note that Emacs 23 and later
              already contain the official GUI support via the NS (Cocoa) port for
              Mac OS X 10.4 and later. So if it is good enough for you, then you
              don't need to try this.
            '';
          };

          enableParallelBuilding = true;

          nativeBuildInputs = with pkgs; [ autoconf automake pkg-config ];

          doCheck = false;

          buildInputs = with pkgs;
            with pkgs.darwin.apple_sdk.frameworks; [
              pkgs.darwin.sigtool
              UniformTypeIdentifiers
              AppKit
              Carbon
              Cocoa
              MetalKit
              IOKit
              OSAKit
              Quartz
              QuartzCore
              WebKit
              ImageCaptureCore
              GSS
              ImageIO

              ncurses
              gnutls
              imagemagick
              jansson
              libxml2
              libgccjit
              librsvg
              sqlite
              texinfo
            ];

          preConfigure = "./autogen.sh";

          configureFlags = [
            "LDFLAGS=-L${pkgs.ncurses.out}/lib"
            # for a more reproducible build
            "--disable-build-details"
            "--with-modules"
            "--with-mac"
            "--with-xml2=yes"
            "--with-gnutls=yes"
            "--with-mac-metal"
            "--with-rsvg"
            "--with-imagemagick"
            "--with-native-compilation"
            "--with-x=no"
            "--with-xpm=no"
            "--with-jpeg=no"
            "--with-png=no"
            "--with-gif=no"
            "--with-tiff=no"
            "--enable-mac-app=$$out/Applications"
          ];

          postPatch = with pkgs;
            lib.concatStringsSep "\n" [
              ''
                substituteInPlace lisp/international/mule-cmds.el \
                  --replace /usr/share/locale ${gettext}/share/locale
              ''
              ''
                for makefile_in in $(find . -name Makefile.in -print); do
                  substituteInPlace $makefile_in --replace /bin/pwd pwd
                done
              ''
              (let
                backendPath = (lib.concatStringsSep " "
                  (builtins.map (x: ''\"-B${x}\"'') [
                    # Paths necessary so the JIT compiler finds its libraries:
                    "${lib.getLib libgccjit}/lib"
                    "${lib.getLib libgccjit}/lib/gcc"
                    "${lib.getLib stdenv.cc.libc}/lib"

                    # Executable paths necessary for compilation (ld, as):
                    "${lib.getBin stdenv.cc.cc}/bin"
                    "${lib.getBin stdenv.cc.bintools}/bin"
                    "${lib.getBin stdenv.cc.bintools.bintools}/bin"
                  ]));
              in ''
                substituteInPlace lisp/emacs-lisp/comp.el --replace \
                  "(defcustom native-comp-driver-options nil" \
                  "(defcustom native-comp-driver-options '(${backendPath})"
              '')
            ];

          postInstall = ''
            mkdir -p $out/share/emacs/site-lisp
            cp ${./site-start.el} $out/share/emacs/site-lisp/site-start.el
            $out/bin/emacs --batch -f batch-byte-compile $out/share/emacs/site-lisp/site-start.el
            siteVersionDir=`ls $out/share/emacs | grep -v site-lisp | head -n 1`
            rm -r $out/share/emacs/$siteVersionDir/site-lisp

            ln -snf $out/lib/emacs/*/native-lisp $out/Applications/Emacs.app/Contents/native-lisp

            echo "Generating native-compiled trampolines..."
            # precompile trampolines in parallel, but avoid spawning one process per trampoline.
            # 1000 is a rough lower bound on the number of trampolines compiled.
            $out/bin/emacs --batch --eval "(mapatoms (lambda (s) \
              (when (subr-primitive-p (symbol-function s)) (print s))))" \
              | xargs -n $((1000/NIX_BUILD_CORES + 1)) -P $NIX_BUILD_CORES \
                $out/bin/emacs --batch -l comp --eval "(while argv \
                  (comp-trampoline-compile (intern (pop argv))))"
            mkdir -p $out/share/emacs/native-lisp
            $out/bin/emacs --batch \
              --eval "(add-to-list 'native-comp-eln-load-path \"$out/share/emacs/native-lisp\")" \
              -f batch-native-compile $out/share/emacs/site-lisp/site-start.el
          '';

          hardeningDisable = [ "format" ]
            ++ (if stdenv.isAarch64 && stdenv.isDarwin then
              [ "stackprotector" ]
            else
              [ ]);
          CFLAGS = "-O3";
          LDFLAGS = "-O3 -L${pkgs.ncurses.out}/lib";
          NATIVE_FULL_AOT = "1";
          LIBRARY_PATH = with pkgs; "${lib.getLib stdenv.cc.libc}/lib";
        };

        defaultPackage = self.packages.${system}.${packageName};
      });
}
