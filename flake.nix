{
  description = "Cole Potrocky's nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.input.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
             let
               nixpkgsConfig = with inputs; {
                 config = {
                   allowUnfree = true;
                 };
                 overlays = [];
               };

               mkDarwinConfig = { host, user }: [
                 (./. + "/hosts/${host}")
                 home-manager.darwinModules.home-manager
                 {
                   nixpkgs = nixpkgsConfig;
                   users.users.${user}.home = "/Users/${user}";
                   home-manager.useUserPackages = true;
                   home-manager.users.${user} = with self.homeManagerModules; {
                     imports = [ (./. + "/hosts/${host}/home") ];
                     nixpkgs.overlays = nixpkgsConfig.overlays;
                   }
                 }
               ]
             in {
               darwinConfigurations = {
                 riverrun = darwin.lib.darwinSystem {
                   inputs = inputs;
                   system = "aarch64-darwin";
                   modules = makeDarwinConfig {
                     host = "riverrun";
                     user = "colepotrocky";
                   }
                 }
               }
             }
}
