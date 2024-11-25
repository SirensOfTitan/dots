{ pkgs, ... }: {
  zed = import ./zed.nix { inherit pkgs; };
}
