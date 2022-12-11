{ pkgs, config, lib, ... }:

rec {
  system.stateVersion = 4;
  nix.package = pkgs.master.nixVersions.nix_2_11;
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
    devspace
    leiningen
    clojure
    dive
    dbmate
    brotli
    babashka
    parallel
    ripgrep
    jq
    htmlq
    iina
    gawk
    cachix
    colima
    tree
    vim
    tree
    shellcheck
    gitAndTools.delta
    vollkorn

    # for emacs autoformatting
    master.nodejs-16_x
    master.nodePackages.prettier
    master.nodePackages.pnpm
    yarn

    cookiecutter
    python310Packages.python-lsp-server
    black

    # (postgresql_15.withPackages (p: [ p.postgis ]))

    docker
    docker-compose
    lldb

    curl
    charles
    shellcheck
    tldr
    nixfmt
    fd

    # Probably broken until we can get newer Apple SDK libraries
    # inside nix.
    # emacs-mac
    cmake
    time
    coreutils

    fastmod
    kubeconform
  ];

  homebrew = {
    brewPrefix = "/opt/homebrew/bin";
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
      "gcc"
      "postgresql@14"
      "postgis"
      # "railwaycat/emacsmacport/emacs-mac"
      "libgccjit"
      "kubectl"
      "kubectx"
      "krew"
      "helm"
      "pyright"
    ];

    casks = [
      "anki"
      "superproductivity"
      "cheatsheet"
      "insomnia"
      "shottr"
      "transmission"
      # Has some permission issues in macOS for the nix version.
      "iterm2"
      "signal"
      "spotify"
      "telegram"
      "vlc"
    ];

    extraConfig = ''
      brew "railwaycat/emacsmacport/emacs-mac", args: ["with-native-compilation", "with-librsvg", "with-starter"]
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
