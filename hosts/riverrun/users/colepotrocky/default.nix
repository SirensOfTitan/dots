{ config, lib, pkgs, self, ... }:

{
  home.stateVersion = "21.05";

  home.packages = with pkgs; [ exercism kubectl libtool ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # targets.genericLinux.enable = true;

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Cole Potrocky";
    userEmail = "cole@potrocky.com";

    iniContent.pull.rebase = "true";
    iniContent.merge.ff = "no";
    iniContent.merge.conflictstyle = "diff3";
  };

  # programs.tmux = {
  #   enable = true;
  #   config = {

  #     keyMode = "vi";
  #     mouse = true;
  #   }
  # };

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

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Iosevka Raisa";
          style = "Regular";
        };
        italic = {
          family = "Iosevka Raisa";
          style = "Italic";
        };
        size = 15.0;
        window = {
          option_as_alt = "OnlyLeft";
          dynamic_padding = true;
          padding = let amount = 8;
          in {
            x = amount;
            y = amount;
          };
        };
        colors = {
          draw_bold_text_with_bright_colors = true;
          primary = {
            background = "0xfdf6e3";
            foreground = "0x586e75";
          };
          normal = {
            black = "0x073642";
            red = "0xdc322f";
            green = "0x859900";
            yellow = "0xb58900";
            blue = "0x268bd2";
            magenta = "0xd33682";
            cyan = "0x2aa198";
            white = "0xeee8d5";
          };
          bright = {

            black = "0x002b36";
            red = "0xcb4b16";
            green = "0x586e75";
            yellow = "0x657b83";
            blue = "0x839496";
            magenta = "0x6c71c4";
            cyan = "0x93a1a1";
            white = "0xfdf6e3";
          };
        };
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
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

    sessionVariables = let editor = "${pkgs.neovim}/bin/nvim";
    in {
      VISUAL = editor;
      EDITOR = editor;
      ZSH_AUTOSUGGEST_USE_ASYNC = 1;
      PATH = "$HOME/.bun/bin:$HOME/.cargo/bin:$PATH";
      # Gray color for autosuggestions
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=247";
    };

    shellAliases = {
      "nix!" = "(cd ~/dots && darwin-rebuild switch --flake .)";
      "reload!" = "source $HOME/.zshrc";
      "drive" = "cd ~/Library/Mobile\\ Documents/com~apple~CloudDocs/";
      "glibtool" = "${pkgs.libtool}/bin/libtool";
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
