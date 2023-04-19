{ config, lib, pkgs, self, ... }:

{
  home.stateVersion = "21.05";

  home.packages = with pkgs; [
    k9s
    awscli2
    ssm-session-manager-plugin
    aws-vault
    python39
    terraform
    terragrunt
    go
    vscode
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Cole Potrocky";
    userEmail = "cole@rebelliondefense.com";

    iniContent = {
      # for 1password-based git commit signing.
      commit.gpgSign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "/Users/cole/.config/git/allowed_signers";
      gpg."ssh".program =
        "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      user.signingkey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvvWufvRldrjYM/psagvoWqqz7gR42+9va9OlmHq9va";

      # For magit-forge
      gitlab."gitlab.rebellion.dev/api/v4" = { user = "cole"; };

      # For code review
      github."git.tools.rebellion.dev".user = "cole";
      github."api.git.tools.rebellion.dev".user = "cole";
      github."api.git.tools.rebellion.dev/graphql".user = "cole";
      github."api.git.tools.rebellion.dev/v3".user = "cole";

      github."git.tools.rebellion.dev/api".user = "cole";

      github."git.tools.rebellion.dev/api/v3".user = "cole";

      pull.rebase = "true";
      merge.ff = "no";
      merge.conflictstyle = "diff3";
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

      alias gb="git-branchless"

      eval "$(/opt/homebrew/bin/brew shellenv)"

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
      LD_LIBRARY_PATH = "${lib.makeLibraryPath [ pkgs.postgresql ]}";
      GOPRIVATE = "rebellion.dev,us.rebellion.dev";
      PATH = "$PATH:$HOME/.krew/bin";
      LSP_USE_PLISTS = "true";
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
