{
  description = "Cole Potrocky's nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    git-branchless.url = "github:arxanas/git-branchless";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    mozilla-overlay.url = "github:mozilla/nixpkgs-mozilla";

    # language learning
    mpvacious = {
      url = "github:Ajatt-Tools/mpvacious";
      flake = false;
    };

    devenv.url = "github:cachix/devenv/latest";
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

  outputs = inputs@{ self, nixpkgs, nixpkgs-master, devenv, darwin, home-manager
    , nur, mpvacious, git-branchless, mozilla-overlay, ... }:
    let
      nixpkgsConfig = {
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
          git-branchless.overlay
          mozilla-overlay.overlays.rust
          nur.overlay
          (final: prev: {
            config.allowUnfree = true;
            config.allowAliases = true;

            master = nixpkgs-master.legacyPackages.${prev.system};
            devenv-pkgs = devenv.packages.${prev.system};

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
          home-manager.users.${user} = {
            imports = [ (./. + "/hosts/${host}/users/${user}") ];
          };

          home-manager.extraSpecialArgs = { inherit self; };
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
