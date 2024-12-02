{ pkgs }:
{
  # This should deep merge userSettings, it doesn't seem to do that now, fix:
  makeZedConfig =
    {
      userSettings ? { },
    }:
    {
      enable = true;
      package = pkgs.emptyDirectory;

      extensions = [
        "awk"
        "clojure"
        "deno"
        "html"
        "nix"
        "ruff"
        "toml"
        "biome"
        "docker-compose"
        "dockerfile"
        "elisp"
        "env"
        "git-firefly"
        "graphql"
        "graphviz"
        "http"
        "make"
        "mermaid"
        "relay"
        "sql"
        "swift"
        "terraform"
      ];

      userSettings = pkgs.lib.recursiveUpdate {
        tab_bar.show = false;
        indent_guides = {
          enabled = true;
          coloring = "indent_aware";
        };
        load_direnv = "shell_hook";
        inlay_hints.enabled = true;
        auto_signature_help = true;
        project_panel.auto_fold_dirs = true;
        slash_commands = {
          docs.enabled = true;
          project.enabled = true;
        };
        # Use zed commit editor
        terminal.env.EDITOR = "zed --wait";

        buffer_font_family = "PragmataPro Mono Liga";
        # features.inline_completion_provider = "copilot";
        telemetry = {
          metrics = false;
          diagnostics = false;
        };
        vim_mode = true;
        ui_font_size = 16;
        buffer_font_size = 16;
        theme = {
          mode = "system";
          light = "Rosé Pine Dawn";
          dark = "One Dark";
        };

        lsp.nil.settings.formatting.command = [ "nixfmt" ];

        languages =
          let
            tsCommon = {
              inlay_hints = {
                enabled = true;
                show_parameter_hints = false;
                show_other_hints = true;
                show_type_hints = true;
              };

            };
          in
          {
            "TypeScript" = tsCommon;

            "Python" = {
              format_on_save.language_server.name = "ruff";
              formatter.language_server.name = "ruff";
              language_servers = [
                "pyright"
                "ruff"
              ];
            };
          };

        assistant = {
          enable_experimental_live_diffs = true;
          version = "2";
        };
      } userSettings;

      userKeymaps = [
        {
          context = "Editor && vim_mode == normal && !menu";
          bindings = {
            "f f" = "pane::RevealInProjectPanel";
            "g w" = [
              "projects::OpenRecent"
              { "create_new_window" = false; }
            ];
          };
        }
        {
          context = "ProjectPanel";
          bindings = {
            escape = "workspace::ToggleLeftDock";
          };
        }
      ];
    };
}
