{ pkgs, config, lib, ... }:

{
  system.stateVersion = 4;
  nix.package = pkgs.nixUnstable;

  services.nix-daemon.enable = true;
  users.nix.configureBuildUsers = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      vollkorn
      inter
      font-awesome
    ];
  };

  environment.systemPackages = with pkgs; [
    ripgrep
    jq
    tree
    vim
    tree
    shellcheck
    gitAndTools.delta
    cachix
    vollkorn
    rclone
    nextdns
    pandoc
    dnsmasq

    cloudflared
    k9s

    curl
    shellcheck
    ngrok

    cmake
  ];

  # needed to ensure nix env is properly sourced.
  programs.zsh.enable = true;
}
