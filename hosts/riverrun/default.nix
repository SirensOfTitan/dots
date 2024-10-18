{
  pkgs,
  lib,
  nixpkgs,
  inputs,
  ...
}:

rec {
  system.stateVersion = 4;
  nix.package = pkgs.master.nixVersions.nix_2_22;
  nix.configureBuildUsers = true;

  services.nix-daemon.enable = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes ca-derivations
    extra-trusted-users = colepotrocky
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
    packages = with pkgs; [
      vollkorn
      inter
      font-awesome
    ];
  };

  environment.systemPackages = with pkgs; [
    tmux
    babashka
    brotli
    cachix
    clojure
    cloudflared
    cmake
    master.iterm2

    # Things needed for emacs to run properly.
    # nix LSP: Oh so needed.
    master.nil
    master.dockfmt
    master.pngpaste
    master.darwin.libiconv

    zstd
    editorconfig-core-c

    wordnet
    google-cloud-sdk

    master.difftastic
    curl
    dnsmasq
    docker
    shfmt

    (
      (master.emacs29-macport.overrideAttrs {
        version = "29.4";
        src = pkgs.fetchFromBitbucket {
          owner = "mituharu";
          repo = "emacs-mac";
          rev = "7cc5e67629363d9e98f65e4e652f83bb4e0ee674";
          hash = "sha256-Uv0AX0d5JLgxHlBD70OIDOO/ImMA6hH1fs5hCuMxw7c=";
        };
      }).override
      { withNativeCompilation = true; }
    )
    fastmod
    fd
    ffmpeg
    gawk
    gitAndTools.delta
    htmlq
    imagemagick
    emacs-lsp-booster
    jdk
    jq
    k9s
    kubectx
    yt-dlp
    master.nix-index
    master.devenv
    nix-tree
    (master.python3.withPackages (
      p: with p; [
        numpy
        sentencepiece
        pip
        # Needed for lsp-bridge:
        epc
        orjson
        sexpdata
        six
        setuptools
        paramiko
        rapidfuzz
      ]
    ))
    neovim
    nextdns
    nix-prefetch-git

    nixfmt-rfc-style
    pandoc
    parallel
    rclone
    ripgrep
    shellcheck
    time
    tldr
    tree
    vim
    ngrok
    master.typst
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };
    global = {
      lockfiles = false;
      brewfile = true;
    };

    taps = [
      "homebrew/bundle"
      "oven-sh/bun"
      "homebrew/cask"
      "homebrew/cask-versions"
      "homebrew/core"
    ];

    brews = [
      "colima"
      "pulumi"
      "cocoapods"
      "editorconfig"
      "coreutils"
      "ast-grep"
    ];

    casks = [
      "anki"
      "cheatsheet"
      "1password-cli"
      "rocket"
      "calibre"
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
