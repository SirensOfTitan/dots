{
  config,
  lib,
  pkgs,
  ...
}@imports:

with lib;

let
  jsonFormat = pkgs.formats.json { };
in
{

  options = {
    programs.my-zed = {
      enable = mkEnableOption "Enables zed editor config";
      settings = mkOption {
        type = jsonFormat.type;
        default = { };
      };

      extensions = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };
  };

  config =
    let
      cfgRef = config.programs.my-zed;
      defaultConfig = import ./config.nix imports;

      mergedExtensions = defaultConfig.extensions ++ cfgRef.extensions;

      mergedUserSettings = (recursiveUpdate defaultConfig.settings cfgRef.settings) // {
        auto_install_extensions = lib.genAttrs mergedExtensions (_: true);
      };
    in
    mkIf cfgRef.enable {
      home.file."${config.xdg.configHome}/zed/settings.json" = {
        source = jsonFormat.generate "zed-settings" mergedUserSettings;
        mutable = true;
        force = true;
      };

      home.file."${config.xdg.configHome}/zed/keymap.json" = {
        source = jsonFormat.generate "zed-keymap" defaultConfig.keymap;
        mutable = true;
        force = true;
      };
    };
}
