{ pkgs, config, ... }:

{
  system.stateVersion = 4;
  nix.package = pkgs.nixUnstable;

  services.nix-daemon.enable = true;
  users.nix.configureBuildUsers = true;

  environment.systemPackages = with pkgs; [
    direnv
    ripgrep
    jq
    tree
    lorri
    vim
  ];

  # Enable caching
  # XXX: Copied verbatim from https://github.com/iknow/nix-channel/blob/7bf3584e0bef531836050b60a9bbd29024a1af81/darwin-modules/lorri.nix
  launchd.user.agents = {
    "lorri" = {
      serviceConfig = {
        WorkingDirectory = (builtins.getEnv "HOME");
        EnvironmentVariables = { };
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/var/tmp/lorri.log";
        StandardErrorPath = "/var/tmp/lorri.log";
      };
      script = ''
        source ${config.system.build.setEnvironment}
        exec ${pkgs.lorri}/bin/lorri daemon
      '';
    };
  };

}
