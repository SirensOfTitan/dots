{
  pkgs,
  lib,
  nixpkgs,
  inputs,
  ...
}:

rec {
  system.stateVersion = 4;
  nix.package = pkgs.master.nixVersions.nix_2_30;

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
    master.iterm2

    master.bcftools

    # Things needed for emacs to run properly.
    # nix LSP: Oh so needed.
    master.nixd
    master.nil
    master.pngpaste
    master.darwin.libiconv
    master.tinymist
    master.bun
    master.nodejs_22
    master.poetry
    master.jujutsu
    ccache

    flox

    zstd
    editorconfig-core-c

    google-cloud-sdk
    mkvtoolnix

    master.difftastic
    curl
    dnsmasq
    docker
    shfmt

    master.uv
    fastmod
    fd
    ffmpeg
    gawk
    gitAndTools.delta
    python312Packages.fonttools
    htmlq
    imagemagick
    # emacs-lsp-booster
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
        # # Needed for lsp-bridge:
        # epc
        # orjson
        # sexpdata
        # six
        # setuptools
        # paramiko
        # rapidfuzz
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
    master.woff2
    watchman
    meld
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
      "facebook/fb"
      "homebrew/cask"
      "homebrew/cask-versions"
      "homebrew/core"
    ];

    brews = [
      "gh"
      "xcbeautify"
      "colima"
      "idb-companion"
      "cocoapods"
      "editorconfig"
      "coreutils"
      "ast-grep"
      "xcode-build-server"
    ];

    casks = [
      "cheatsheet"
      "1password-cli"
      "slack"
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
    expose-group-apps = false;
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
