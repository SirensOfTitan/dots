{
  description = "Cole Potrocky's nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    mac-app-util.url = "github:hraban/mac-app-util";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-branchless.url = "github:arxanas/git-branchless";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-master,
      devenv,
      darwin,
      home-manager,
      mpvacious,
      fenix,
      mac-app-util,
      ...
    }:
    let
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
          allowBroken = true;
          allowAliases = true;
          nix.gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
          };
          nix.autoOptimiseStore = true;
          nix.trustedUsers = [
            "root"
            "@wheel"
          ];
        };
        overlays = [
          fenix.overlays.default
          (final: prev: {
            config = prev.config // {
              allowUnfree = true;
              allowAliases = true;
            };

            master = nixpkgs-master.legacyPackages.${prev.system};
            devenv-pkgs = devenv.packages.${prev.system};

            charles =
              if prev.stdenv.isDarwin then (prev.callPackage ./overlays/charles.nix { }) else prev.charles;

            myLib = import ./lib { pkgs = prev; };
          })
        ];
      };

      mkDarwinConfig =
        { host, user }:
        [
          (./. + "/hosts/${host}")
          home-manager.darwinModules.home-manager
          mac-app-util.darwinModules.default
          {
            nixpkgs = nixpkgsConfig;

            users.users.${user}.home = "/Users/${user}";
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ mac-app-util.homeManagerModules.default ];
            home-manager.useGlobalPkgs = true;
            home-manager.users.${user} = {
              imports = [ (./. + "/hosts/${host}/users/${user}") ];
            };

            home-manager.extraSpecialArgs = {
              inherit self inputs;
            };
          }
        ];
    in
    {

      darwinConfigurations = {
        riverrun = darwin.lib.darwinSystem {
          inputs = inputs;
          system = "aarch64-darwin";
          modules = mkDarwinConfig {
            host = "riverrun";
            user = "colepotrocky";
          };
        };

        galadriel = darwin.lib.darwinSystem {
          inputs = inputs;
          system = "aarch64-darwin";
          modules = mkDarwinConfig {
            host = "galadriel";
            user = "colep";
          };
        };
      };
    };
}
