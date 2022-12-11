{ pkgs, fetchFromGithub, lib, ... }:

{
  colima = pkgs.colima.overrideAttrs (prev: {
    version = "support-vz-git";
    src = fetchFromGithub {
      owner = "abiosoft";
      repo = "colima";
      # Head of support-vz branch.
      rev = "f959232a2322e4b61217ecba0b92ef4618783cbf";
      sha256 = lib.fakeSha256;
    };
  });
}
