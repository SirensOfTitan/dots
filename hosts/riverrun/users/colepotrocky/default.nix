{ config, lib, pkgs, self, ... }:

{
  home.packages = with pkgs; [
    exercism
  ];

  # programs.zsh = {
  #   enable = false;
  #   enableAutosuggestions = true;
  #   enableCompletion = true;
  #   enableSyntaxHighlighting = true;
  #   autocd = true;
  #   history = {
  #     ignoreDups = true;
  #     ignoreSpace = true;
  #     path = "${config.xdg.dataHome}/zsh/zsh_history";
  #     save = 1000000;
  #     share = true;
  #   };
  #   initExtra = ''
  #   # Gray color for autosuggestions
  #   ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'
  #   '';
  #   shellAliases = {
  #     ".." = "cd ..";
  #   };

  #   plugins = with self.inputs; lib.flatten [
  #     {
  #       src = zsh-completions;
  #       name = "zsh-completions";
  #       file = "init.zsh";
  #     }
  #     {
  #       src = zsh-autosuggestions
  #     }
  #   ]
  # };
}
