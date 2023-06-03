{ pkgs, config, lib, ... }:

rec {
  system.stateVersion = 4;
  nix.package = pkgs.master.nixVersions.nix_2_16;
  nix.configureBuildUsers = true;

  services.nix-daemon.enable = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nix.settings.trusted-substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://sirensoftitan.cachix.org"
  ];

  nix.settings.substituters = nix.settings.trusted-substituters;

  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "sirensoftitan.cachix.org-1:XzIOQ6jSxMXnoiHYFkpqN7PjEMXuXb3LYF9XlqNZAoQ="
  ];

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [ vollkorn inter font-awesome ];
  };

  environment.systemPackages = with pkgs; [
    babashka
    brotli
    cachix
    charles
    charles
    clojure
    cloudflared
    cmake
    coreutils
    curl
    dnsmasq
    docker
    fastmod
    fd
    ffmpeg
    gawk
    gitAndTools.delta
    htmlq
    iina
    imagemagick
    jdk
    jq
    k6
    k9s
    kubectx
    leiningen
    lldb
    macfuse-stubs
    mariadb
    master.clojure-lsp
    master.nix-index
    master.nodePackages.pnpm
    master.nodePackages.prettier
    master.nodePackages.pyright
    master.nodejs-18_x
    neovim
    nextdns
    nixfmt
    pandoc
    parallel
    python310Packages.libcst
    rclone
    ripgrep
    scdl
    shellcheck
    time
    tldr
    tree
    tree
    vim
    vollkorn
    vscode
    yarn
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    global = {
      lockfiles = false;
      brewfile = true;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-versions"
      "homebrew/core"
      "railwaycat/emacsmacport"
    ];

    brews = [
      "colima"
      "pulumi"
      "cocoapods"
      "gcc"
      # "railwaycat/emacsmacport/emacs-mac"
      "youtube-dl"
      "libgccjit"
    ];

    casks = [
      "anki"
      "cheatsheet"
      "rocket"
      "calibre"
      "insomnia"
      "kindle"
      "slack"
      "shottr"
      "transmission"
      # Has some permission issues in macOS for the nix version.
      "signal"
      "spotify"
      "telegram"
      "zoom"
      "vlc"
    ];

    extraConfig = ''
      brew "railwaycat/emacsmacport/emacs-mac", args: ["HEAD", "with-native-compilation", "with-librsvg", "with-starter"]
    '';
  };

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
