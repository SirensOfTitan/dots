{ pkgs, config, lib, ... }:

{
  system.stateVersion = 4;
  nix.package = pkgs.nixUnstable;

  services.nix-daemon.enable = true;
  users.nix.configureBuildUsers = true;

  nix.extraOptions = ''
    auto-optimise-store = true
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

    colima
    docker

    curl
    shellcheck
    ngrok

    texlive.combined.scheme-medium

    cmake

    anki-bin
    firefox-dev-edition
    iterm2
  ];

  # needed to ensure nix env is properly sourced.
  programs.zsh.enable = true;

  # system defaults
  system.defaults.dock = {
    autohide = true;
    orientation = "left";
    show-recents = false;
    expose-group-by-app = false;
    mru-spaces = false;
    # Disable all hot corners
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    QuitMenuItem = true;
    FXEnableExtensionChangeWarning = false;
  };

  # Login and lock screen
  system.defaults.loginwindow = {
    GuestEnabled = false;
    DisableConsoleAccess = true;
  };
}
