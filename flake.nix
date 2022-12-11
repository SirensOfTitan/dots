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
    , mpvacious, ... }:
    let
      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
          allowBroken = true;
          allowAliases = true;
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
            config.allowUnfree = true;
            config.allowAliases = true;

            master = nixpkgs-master.legacyPackages.${prev.system};

            # lima = prev.lima.overrideAttrs (prevp: {
            #   version = "0.14.0-local";
            #   src = prev.fetchFromGitHub {
            #     owner = "lima-vm";
            #     repo = "lima";
            #     rev = "0e431c5e6d981d04536b140b1bf08b82da3d71cf";
            #     sha256 = "sha256-B2l2OeKqRXMZA8mDdFzeuOsTh9HxCZGSNxQBoeOmAm8=";
            #   };
            #   vendorSha256 = prev.lib.fakeSha256;
            # });

            lima = let
              version = "0.14.0-master";
              src = prev.fetchFromGitHub {
                owner = "lima-vm";
                repo = "lima";
                rev = "0e431c5e6d981d04536b140b1bf08b82da3d71cf";
                sha256 = "sha256-B2l2OeKqRXMZA8mDdFzeuOsTh9HxCZGSNxQBoeOmAm8=";
              };
            in (prev.lima.override rec {
              buildGoModule = args:
                prev.buildGoModule (args // {
                  inherit src version;
                  vendorSha256 =
                    "sha256-7WqUR5JG+W8vQI62ScTXNA5OLWHQbAlzn4M7eDjOlpE=";
                });
            });

            colima = let
              version = "0.4.6-vz";
              src = prev.fetchFromGitHub {
                owner = "abiosoft";
                repo = "colima";
                # Head of support-vz branch.
                rev = "f959232a2322e4b61217ecba0b92ef4618783cbf";
                sha256 = "sha256-1VDr/zJfTNblURTTArAED9xZhAZy6Qu48+5GUxA8ArE=";
                leaveDotGit = true;
                postFetch = ''
                  git -C $out rev-parse --short HEAD > $out/.git-revision
                  rm -rf $out/.git
                '';
              };
            in (prev.colima.override rec {
              buildGoModule = args:
                prev.buildGoModule (args // {
                  inherit src version;
                  vendorSha256 =
                    "sha256-v0U7TorUwOtBzBQ/OQQSAX6faDI1IX/IDIJnY8UFsu8=";
                });
            });

            firefox-dev-edition =
              prev.callPackage ./overlays/firefox-dev-edition.nix { };
            charles = if prev.stdenv.isDarwin then
              (prev.callPackage ./overlays/charles.nix { })
            else
              prev.charles;
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

        galactica = darwin.lib.darwinSystem {
          inputs = inputs;
          system = "aarch64-darwin";
          modules = mkDarwinConfig {
            host = "galactica";
            user = "cole";
          };
        };
      };
    };
}
