{
  config,
  lib,
  pkgs,
  self,
  ...
}:

{
  home.stateVersion = "21.05";

  home.packages = with pkgs; [
    kubectl
    master.fira
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # targets.genericLinux.enable = true;

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Cole Potrocky";
    userEmail = "cole.potrocky@functionhealth.com";

    iniContent.pull.rebase = "true";
    iniContent.merge.ff = "no";
    iniContent.merge.conflictstyle = "diff3";
  };

  programs.zed-editor = self.lib.zed.makeZedConfig {
    assistantConfig = {
      default_model = {
        provider = "copilot_chat";
        model = "gpt-4o";
      };
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
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
          # This function will open the file in emacsclient, if we're in emacs,
          # otherwise will fall back to editor.
          if [ -n "$INSIDE_EMACS" ]; then
              vterm_cmd find-file "$(realpath "''${@:-.}")"
          else
              $EDITOR "$(realpath "''${@:-.}")"
          fi
      }

      # Move to root of projectile project.
      pr() {
          # vterm_cmd only exists in an emacs context, so we need to determine if
          # we're in emacs to run this, and if we're not, fall back to git rev-parse cd:
          if [ -n "$INSIDE_EMACS" ]; then
              vterm_cmd projectile-project-root
          else
              cd "$(git rev-parse --show-toplevel)" || exit 1
          fi
      }
    '';

    sessionVariables =
      let
        editor = "${pkgs.neovim}/bin/nvim";
      in
      {
        VISUAL = editor;
        EDITOR = editor;
        ZSH_AUTOSUGGEST_USE_ASYNC = 1;
        PATH = "/opt/homebrew/bin:$HOME/.bun/bin:$HOME/.cargo/bin:$PATH";
        # Gray color for autosuggestions
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=247";
      };

    shellAliases = {
      "nix!" = "(cd ~/dots && darwin-rebuild switch --flake .)";
      "reload!" = "source $HOME/.zshrc";
      "drive" = "cd ~/Library/Mobile\\ Documents/com~apple~CloudDocs/";
    };

    plugins =
      with self.inputs;
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
