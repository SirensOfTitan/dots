{ lib, ... }:

{
  extensions = [
    "awk"
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
    "sql"
    "terraform"
  ];

  settings = {
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
    features.inline_completion_provider = "none";
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
  };

  keymap = [
    {
      context = "Editor && (vim_mode == normal || vim_mode == visual) && !VimWaiting && !menu";
      bindings = {
        # Projects/nav
        "space space" = "file_finder::Toggle";
        "space p p" = [
          "projects::OpenRecent"
          { "create_new_window" = false; }
        ];
        "space p P" = [
          "projects::OpenRecent"
          { "create_new_window" = true; }
        ];

        # insert
        "space i u 4" = "editor::InsertUuidV4";
        "space i u 7" = "editor::InsertUuidV7";

        # Buffer
        "space <" = "tab_switcher::Toggle";

        # Code
        "space c a" = "editor::ToggleCodeActions";
        "space c x" = "diagnostics::Deploy";

        # Misc toggles
        "space t i" = "editor::ToggleInlayHints";
        "space t w" = "editor::ToggleSoftWrap";

        "space o t" = "terminal_panel::ToggleFocus";
        # space o T: todo
        "space o p" = "pane::RevealInProjectPanel";

        # Git
        "space g [" = "editor::GoToHunk";
        "space g ]" = "editor::GoToPrevHunk";
        "space g b" = "branches::OpenRecent";

        # Notes:
        "space n p" = "markdown::OpenPreview";
        "space n P" = "markdown::OpenPreviewToTheSide";

        # Search
        "space /" = "pane::DeploySearch";

        # AI
        "space a i" = "assistant::ToggleFocus";

      };
    }
    {
      context = "EmptyPane || SharedScreen";
      bindings = {
        "space space" = "file_finder::Toggle";
        "space p p" = [
          "projects::OpenRecent"
          { "create_new_window" = false; }
        ];
      };
    }
    {
      context = "Editor && vim_mode == normal && !VimWaiting && !menu";
      bindings = {
        "space c r" = "editor::Rename";

      };
    }
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
}
