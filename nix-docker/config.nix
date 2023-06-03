{ config, lib, pkgs, ... }:

{
  system.stateVersion = 4;
  nix.package = pkgs.master.nixVersions.nix_2_11;
  nix.configureBuildUsers = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = with pkgs; [ openssh ];
}
