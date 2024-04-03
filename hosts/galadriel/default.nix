{ pkgs, lib, nixpkgs, inputs, ... }:

let
  linuxSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ] pkgs.system;
  darwin-builder = lib.nixosSystem {
    system = linuxSystem;
    modules = [
      "${inputs.nixpkgs}/nixos/modules/profiles/macos-builder.nix"
      {
        virtualisation.host.pkgs = pkgs;
        system.nixos.revision = lib.mkForce null;
      }
    ];
  };
in rec {
  system.stateVersion = 4;
  nix.package = pkgs.master.nixVersions.nix_2_16;
  nix.configureBuildUsers = true;

  services.nix-daemon.enable = true;

  nix.distributedBuilds = true;
  nix.buildMachines = [{
    protocol = "ssh-ng";
    hostName = "ssh://builder@localhost";
    system = linuxSystem;
    maxJobs = 4;
    sshKey = "/etc/nix/builder_ed25519";
    supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
  }];

  launchd.daemons.darwin-builder = {
    command =
      "${darwin-builder.config.system.build.macos-builder-installer}/bin/create-builder";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/log/darwin-builder.log";
      StandardErrorPath = "/var/log/darwin-builder.log";
      WorkingDirectory = "/etc/nix/";
    };
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes ca-derivations
    extra-trusted-users = colepotrocky
    builders = ssh-ng://builder@linux-builder aarch64-linux /etc/nix/builder_ed25519 4 - - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=
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
    tmux
    babashka
    brotli
    cachix
    master.iterm2

    # Things needed for emacs to run properly.
    # nix LSP: Oh so needed.
    master.nil
    master.dockfmt
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
    (master.emacs29-macport.override (args: { withNativeCompilation = true; }))
    fastmod
    fd
    gawk
    gitAndTools.delta
    iina
    imagemagick
    emacs-lsp-booster
    jdk
    jq
    k6
    k9s
    kubectx
    lldb
    master.nix-index
    master.nodePackages.pnpm
    master.nodePackages.prettier
    master.nodePackages.pyright
    master.nodejs-18_x
    (master.python3.withPackages (p:
      with p; [
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
      ]))
    neovim
    google-cloud-sdk
    nextdns
    nixfmt
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
    watchman
    vscode
    yarn
    ngrok
    terraform
    bfg-repo-cleaner
    master.act
    master.helix
    master.poetry
    master.git-branchless
    master.k6
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
      # Has some permission issues in macOS for the nix version.
      "signal"
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
