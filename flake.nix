{
  description = "Cole Potrocky's nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    emacs-mac.url = "path:./overlays/emacs-mac";

    # language learning
    mpvacious = {
      url = "github:Ajatt-Tools/mpvacious";
      flake = false;
    };

    # zsh plugins
    zit = {
      url = "github:thiagokokada/zit";
      flake = false;
    };
    zim-completion = {
      url = "github:zimfw/completion";
      flake = false;
    };
    zim-environment = {
      url = "github:zimfw/environment";
      flake = false;
    };
    zim-input = {
      url = "github:zimfw/input";
      flake = false;
    };
    zim-git = {
      url = "github:zimfw/git";
      flake = false;
    };
    zim-ssh = {
      url = "github:zimfw/ssh";
      flake = false;
    };
    zim-utility = {
      url = "github:zimfw/utility";
      flake = false;
    };
    zsh-pure = {
      url = "github:sindresorhus/pure";
      flake = false;
    };
    zsh-autopair = {
      url = "github:hlissner/zsh-autopair";
      flake = false;
    };
    zsh-completions = {
      url = "github:zsh-users/zsh-completions";
      flake = false;
    };
    zsh-history-substring-search = {
      url = "github:zsh-users/zsh-history-substring-search";
      flake = false;
    };
    zsh-syntax-highlighting = {
      url = "github:zsh-users/zsh-syntax-highlighting";
      flake = false;
    };
    zsh-system-clipboard = {
      url = "github:kutsan/zsh-system-clipboard";
      flake = false;
    };
    zsh-async = {
      url = "github:mafredri/zsh-async";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-master, darwin, home-manager, nur
    , emacs-mac, mpvacious, ... }:
    let
      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
          allowBroken = true;
          nix.gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 30d";
          };
          nix.autoOptimiseStore = true;
          nix.trustedUsers = [ "root" "@wheel" ];
        };
        overlays = [
          nur.overlay
          (final: prev: {
            anki-bin = prev.anki-bin.overrideAttrs (old: {
              meta.platforms = [ "aarch64-darwin" ];
              src = prev.fetchurl {
                url =
                  "https://apps.ankiweb.net/downloads/beta/anki-2.1.50%2Bbeta2_db804d95-mac-qt6-apple.dmg";
                name = "anki-mac-qt6.dmg";

                sha256 = "sha256-rbioj4/z8N9Yt50+SLC08bDhRT119eocq1cX/12esGE=";
              };

              version = "2.1.50";
            });

            master = nixpkgs-master.legacyPackages.${prev.system};

            firefox-dev-edition =
              prev.callPackage ./overlays/firefox-dev-edition.nix { };
            charles = if prev.stdenv.isDarwin then
              (prev.callPackage ./overlays/charles.nix { })
            else
              prev.charles;

            emacs-mac = emacs-mac.defaultPackage.${prev.system};

            firefox-1password =
              prev.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon {
                pname = "1password-beta";
                version = "beta";
                addonId = "{25fc87fa-4d31-4fee-b5c1-c32a7844c063}";
                url =
                  "https://c.1password.com/dist/1P/b5x/firefox/beta/latest.xpi";
                sha256 = "sha256-fAzJL2m/93/PoF8fGN3bl8C95S/d2rc4KpGJcw9Amw8";
                meta =
                  prev.nur.repos.rycee.firefox-addons.onepassword-password-manager.meta;
              };
          })
        ];
      };

      mkDarwinConfig = { host, user }: [
        (./. + "/hosts/${host}")
        home-manager.darwinModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          users.users.${user}.home = "/Users/${user}";
          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = with self.homeManagerModules; {
            imports = [ (./. + "/hosts/${host}/users/${user}") ];
          };

          home-manager.extraSpecialArgs = rec { inherit self; };
        }
      ];
    in {

      darwinConfigurations = {
        riverrun = darwin.lib.darwinSystem {
          inputs = inputs;
          system = "aarch64-darwin";
          modules = mkDarwinConfig {
            host = "riverrun";
            user = "colepotrocky";
          };
        };
      };
    };
}
