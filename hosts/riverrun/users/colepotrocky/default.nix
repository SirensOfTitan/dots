{ config, lib, pkgs, self, ... }:

{
  home.stateVersion = "21.05";
  home.packages = with pkgs; [
    exercism
    youtube-dl
    heroku
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-dev-edition;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      localcdn

      old-reddit-redirect
      reddit-enhancement-suite

      pkgs.firefox-1password

      react-devtools
    ];

    profiles.default = {
      id = 0;
      settings = {
        "app.update.auto" = false;
        "signon.rememberSignons" = false;
        "devtools.theme" = "dark";
        "browser.shell.checkDefaultBrowser" = false;
        "browser.newtabpage.enabled" = false;
        "browser.newtab.url" = "about:blank";
        "browser.newtabpage.activity-stream.enabled" = false;
        "browser.newtabpage.enhanced" = false;
        "browser.newtab.preload" = false;
        "browser.newtabpage.directory.ping" = "";
        "browser.newtabpage.directory.source" = "data:text/plain,{}";
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.htmlaboutaddons.discover.enabled" = false;
        "extensions.pocket.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "extensions.shield-recipe-client.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "dom.battery.enabled" = false;
        "beacon.enabled" = false;
        "browser.send_pings" = false;
        "browser.fixup.alternate.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "experiments.supported" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
      };
    };
  };

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Cole Potrocky";
    userEmail = "cole@potrocky.com";

    iniContent.pull.rebase = "true";
    iniContent.merge.ff = "no";
    iniContent.merge.conflictstyle = "diff3";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    defaultKeymap = "viins";

    history = {
      ignoreDups = true;
      ignoreSpace = true;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      save = 1000000;
      share = true;
    };

    initExtraBeforeCompInit = ''
    # zimfw
    zstyle ':zim:input' double-dot-expand yes
    zstyle ':zim:ssh' ids /dev/null
    '';

    initExtra = ''
    # keybindings for autosuggest plugin.
    bindkey '^ ' autosuggest-accept
    bindkey '^f' autosuggest-accept

    # backwards search like bash.
    bindkey '^R' history-incremental-search-backward
    # commands for vterm inside of emacs
    vterm_printf() {
        if [ -n "$TMUX" ] && ([ "''${TERM%%-*}" = "tmux" ] || [ "''${TERM%%-*}" = "screen" ]); then
            # Tell tmux to pass the escape sequences through
            printf "\ePtmux;\e\e]%s\007\e\\" "$1"
        elif [ "''${TERM%%-*}" = "screen" ]; then
            # GNU screen (screen, screen-256color, screen-256color-bce)
            printf "\eP\e]%s\007\e\\" "$1"
        else
            printf "\e]%s\e\\" "$1"
        fi
    }
    vterm_prompt_end() {
        vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
    }
    setopt PROMPT_SUBST
    PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'

    vterm_cmd() {
        local vterm_elisp
        vterm_elisp=""
        while [ $# -gt 0 ]; do
            vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
            shift
        done
        vterm_printf "51;E$vterm_elisp"
    }

    ff() {
        vterm_cmd find-file "$(realpath "''${@:-.}")"
    }

    # Move to root of projectile project.
    pr() {
        vterm_cmd projectile-project-root
    }
    '';

    sessionVariables = {
      ZSH_AUTOSUGGEST_USE_ASYNC = 1;
      # Gray color for autosuggestions
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=247";
    };

    shellAliases = {
      "reload!" = "source $HOME/.zshrc";
    };

    plugins = with self.inputs; lib.flatten [
      {
        src = zim-completion;
        name = "zim-completions";
        file = "init.zsh";
      }
      {
        src = zim-environment;
        name = "zim-environment";
        file = "init.zsh";
      }
      {
        src = zim-input;
        name = "zim-input";
        file = "init.zsh";
      }
      {
        src = zim-git;
        name = "zim-git";
        file = "init.zsh";
      }
      {
        src = zim-utility;
        name = "zim-utility";
        file = "init.zsh";
      }
      {
        src = zsh-pure;
        name = "pure";
      }
      {
        src = zsh-autopair;
        name = "zsh-autopair";
      }
      {
        src = zsh-completions;
        name = "zsh-completions";
      }
      {
        src = zsh-syntax-highlighting;
        name = "zsh-syntax-highlighting";
      }
      {
        src = zsh-system-clipboard;
        name = "zsh-system-clipboard";
      }
      {
        src = zsh-history-substring-search;
        name = "zsh-history-substring-search";
      }
    ];
  };
}
