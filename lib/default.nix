{ lib, pkgs, ... }: {
  zed = import ./zed.nix { inherit lib pkgs; };
}
