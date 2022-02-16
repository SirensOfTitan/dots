{ pkgs, config, lib, ... }:

rec {
  system.stateVersion = 4;
  nix.package = pkgs.master.nixVersions.nix_2_6;

  services.nix-daemon.enable = true;
  users.nix.configureBuildUsers = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nix.trustedBinaryCaches = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://sirensoftitan.cachix.org"
  ];

  nix.binaryCaches = nix.trustedBinaryCaches;

  nix.binaryCachePublicKeys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "sirensoftitan.cachix.org-1:XzIOQ6jSxMXnoiHYFkpqN7PjEMXuXb3LYF9XlqNZAoQ="
  ];

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [ vollkorn inter font-awesome ];
  };

  environment.systemPackages = with pkgs; [
    ripgrep
    ffmpeg
    jq
    cachix
    tree
    vim
    tree
    shellcheck
    gitAndTools.delta
    vollkorn
    rclone
    nextdns
    pandoc
    dnsmasq

    # for emacs autoformatting
    nodejs-17_x
    nodePackages.prettier

    cloudflared
    k9s

    colima
    docker
    lldb

    curl
    charles
    shellcheck
    ngrok
    tldr
    nixfmt
    fd

    texlive.combined.scheme-medium

    # Probably broken until we can get newer Apple SDK libraries
    # inside nix.
    # emacs-mac
    cmake
    time
    coreutils

    mpv
    fastmod
    charles
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
