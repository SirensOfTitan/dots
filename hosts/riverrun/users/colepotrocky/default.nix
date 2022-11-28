{ config, lib, pkgs, self, ... }:

{
  home.stateVersion = "21.05";

  home.packages = with pkgs; [ exercism heroku kubectl ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.hello;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      localcdn

      old-reddit-redirect
      reddit-enhancement-suite
      metamask

      react-devtools
    ];

    profiles.default = {
      id = 0;
      settings = {
        "app.update.auto" = false;
        # managed by nix.
        "app.update.enabled" = false;
        "signon.rememberSignons" = false;
        "dom.webnotifications.enabled" = false;
        "geo.enabled" = false;
        "geo.wifi.uri" =
          "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
        "geo.wifi.logging.enabled" = false;
        "device.sensors.enabled" = false;
        "dom.mozTCPSocket.enabled" = false;
        "dom.netinfo.enabled" = false;
        "dom.battery.enabled" = false;
        "dom.telephony.enabled" = false;
        "media.peerconnection.enabled" = false;
        "media.webspeech.recognition.enable" = false;
        "media.webspeech.synth.enabled" = false;
        "media.peerconnection.ice.default_address_only" = true;
        "media.peerconnection.ice.no_host" = true;
        "media.navigator.enabled" = false;
        "media.navigator.video.enabled" = false;
        "media.getusermedia.screensharing.enabled" = false;
        "media.getusermedia.audiocapture.enabled" = false;
        "devtools.theme" = "dark";
        "browser.shell.checkDefaultBrowser" = false;
        "browser.newtabpage.enabled" = false;
        "browser.newtab.url" = "about:blank";
        "startup.homepage_override_url" = "about:blank";
        "browser.newtabpage.activity-stream.enabled" = false;
        "browser.newtabpage.enhanced" = false;
        "browser.newtab.preload" = false;
        "browser.newtabpage.directory.ping" = "";
        "browser.newtabpage.directory.source" = "data:text/plain,{}";
        "browser.urlbar.suggest.searches" = false;
        "browser.search.suggest.enabled" = false;
        "browser.search.update" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.groupLabels.enabled" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.casting.enabled" = false;
        "pdfjs.disabled" = true;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.htmlaboutaddons.discover.enabled" = false;
        "extensions.pocket.enabled" = false;
        "browser.pocket.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "extensions.shield-recipe-client.enabled" = false;
        "network.predictor.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "beacon.enabled" = false;
        "browser.send_pings" = false;
        "browser.send_pings.require_same_host" = true;
        "browser.fixup.alternate.enabled" = false;
        "network.manage-offline-status" = false;
        "security.mixed_content.block_active_content" = true;
        "security.mixed_content.block_display_content" = true;
        "network.jar.open-unsafe-types" = false;
        "network.allow-experiments" = false;
        "camera.control.face_detection.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "security.xpconnect.plugin.unrestricted" = false;
        "security.fileuri.strict_origin_policy" = true;
        "extensions.getAddons.cache.enabled" = false;
        "lightweightThemes.update.enabled" = false;
        "plugin.state.flash" = 0;
        "plugin.state.java" = 0;
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.enabled" = false;
        "browser.uitour.enabled" = false;
        "browser.startup.blankWindow" = false;
        # let nix manage this.
        "extensions.update.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "experiments.supported" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "browser.discovery.enabled" = false;
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

  programs.mpv = {
    enable = true;
    config = {
      "sub-visibility" = "yes";
      "sub-auto" = "fuzzy";
      "sub-font" = "Besley*";
      "sub-font-size" = "60";
      "alang" = "ru, en";
      "slang" = "ru, en";
      "audio-file-auto" = "fuzzy";
      "save-position-on-quit" = "yes";
      "autofit-larger" = "100%x100%";
      "geometry" = "50%:50%";
    };
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
      # Disable incessant remote calls and ssh key accesses
      # What kind of dummy thought of this feature?
      PURE_GIT_PULL=0
    '';

    initExtra = ''
      source <(${pkgs.kubectl}/bin/kubectl completion zsh)
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
      "nix!" = "(cd ~/dots && darwin-rebuild switch --flake .)";
      "reload!" = "source $HOME/.zshrc";
    };

    plugins = with self.inputs;
      lib.flatten [
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
