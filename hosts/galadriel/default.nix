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
    extra-trusted-users = colep
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
    master.tflint
    master.iterm2
    master.git-filter-repo

    # Things needed for emacs to run properly.
    # nix LSP: Oh so needed.
    master.nil
    master.pngpaste
    master.darwin.libiconv

    cmake
    libtool
    binutils
    master.difftastic
    curl
    dnsmasq
    docker
    shfmt
    (
      (master.emacs29-macport.overrideAttrs {
        version = "29.3";
        src = pkgs.fetchFromBitbucket {
          owner = "mituharu";
          repo = "emacs-mac";
          rev = "0386c590892066c4b58388848c2c93c61a505b31";
          hash = "sha256-PrGlD+/LI2X43V5hrzNHilHDQTk194Mn2aKusaZzqk8=";
        };
      }).override
      { withNativeCompilation = true; }
    )
    fastmod
    fd
    gawk
    gitAndTools.delta
    iina
    imagemagick
    emacs-lsp-booster
    jdk
    jq
    k9s
    kubectx
    lldb
    safety-cli
    process-compose
    google-cloud-sql-proxy
    master.nix-index
    master.pyright
    master.nodePackages.pnpm
    master.nodePackages.prettier
    master.nodejs-18_x
    sapling
    gh
    python312Packages.vulture
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
    devenv
    neovim
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    nextdns
    nixfmt-rfc-style
    pandoc
    parallel
    ripgrep
    scdl
    shellcheck
    time
    tldr
    tree
    vim
    vollkorn
    cloudflared
    watchman
    vscode
    yarn
    ngrok
    terraform
    bfg-repo-cleaner
    master.act
    master.helix
    (master.poetry.withPlugins (
      ps: with ps; [
        poetry-plugin-up
        poetry-audit-plugin
      ]
    ))
    master.git-branchless
    master.mermaid-cli
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
      "homebrew/cask-versions"
      "railwaycat/emacsmacport"
    ];

    brews = [
      "colima"
      "pulumi"
      "cocoapods"
      "python@3.12"
      "bun"
      "editorconfig"
      "coreutils"
      "libvterm"
    ];

    casks = [
      "chromium"
      "cheatsheet"
      "rocket"
      "slack"
      "shottr"
      "insomnia"
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
