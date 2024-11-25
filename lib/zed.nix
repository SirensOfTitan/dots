{ pkgs }:
{
  # This should deep merge userSettings, it doesn't seem to do that now, fix:
  makeZedConfig = { userSettings ? { } }: {
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
      "python-refactoring"
      "relay"
      "sql"
      "swift"
      "terraform"
    ];

    userSettings = pkgs.lib.recursiveUpdate {
      tab_bar.show = false;
      buffer_font_family = "PragmataPro Mono Liga";
      # features.inline_completion_provider = "copilot";
      telemetry.metrics = false;
      vim_mode = true;
      ui_font_size = 16;
      buffer_font_size = 16;
      theme = {
        mode = "system";
        light = "Rosé Pine Dawn";
        dark = "One Dark";
      } ;

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
          "g w" = ["projects::OpenRecent" { "create_new_window" = false; }];
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
