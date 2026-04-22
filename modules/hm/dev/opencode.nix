{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.roverp.programs.opencode;
in {
  options = {
    roverp.programs.opencode.enable = lib.mkOption {
      default = true;
      description = "Enable opencode module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      package = pkgs.userPkgs.opencode;

      rules = ''
        # CLI tools
        - when user provides GitHub link:
          - use gh CLI when possible to fetch information
          - if gh doesnt provide required functionality for fetching informaion - use api.github.com endpoints

        - when task requires specific cli tool, but user's machine doesnt have it installed:
          - inform user what required tools are missing, and suggest using `nix-shell -p` to temporarly install them

        # Inset text (any quoted/simulated block inside your answer: examples, posts, letters, documentation, comments, etc.):

        - be concise and to the point
        - avoid filler, empty words
        - don't over explain
        - avoid repeating yourself (or the meaning already conveyed)
        - don't try to be too perfect
        - use hard/aggressive/sad/raw (sometimes cruel) words (not 'safe') sometimes. Avoid sounding corporate, be more sincere
        - avoid using em dashes
        - don't use emojis
        - don't use parallel sentences ("it's not just about X, it's about Y")

        # Code comments

        - use inset text rules
        - avoid writing 'what' comments which explain what code does
        - preffer comments that explain 'why' code is there


        ${builtins.readFile ../../../Configs/.config/opencode/rules/pr-guidelines.md}
      '';

      # Enable after home-manager 26.05 update - and remove ~/.config/opencode/tui.jsonc
      # tui = {
      #   theme = "system";
      #
      #   keybinds = {
      #     leader = "alt+b";
      #   };
      #   scroll_acceleration = {
      #     enabled = true;
      #   };
      # };

      settings = {
        default_agent = "plan";

        lsp = {
          # doesnt work?
          "qmlls" = {
            command = ["qmlls" "-E"];
            extensions = [".qml"];
          };
        };

        agent = {
          cheap = {
            mode = "primary";
            model = "github-copilot/gemini-3-flash-preview";
            description = "Fast iterations for simple tasks and quick fixes";
            temperature = 0.3;
          };

          # explore = {
          #   mode = "subagent";
          #   model = "github-copilot/grok-code-fast-1";
          #   description = "Fast codebase exploration - finding files, searching code, understanding structure";
          #   temperature = 0.3;
          #   tools = {
          #     write = false;
          #     edit = false;
          #     bash = false;
          #   };
          # };
          #
          # general = {
          #   mode = "subagent";
          #   model = "github-copilot/gemini-3-flash-preview";
          #   description = "General-purpose agent for multi-step tasks and research";
          #   temperature = 0.3;
          # };

          docs-writer = {
            mode = "subagent";
            model = "github-copilot/gemini-3-flash-preview";
            description = "Writes and maintains project documentation";
            temperature = 0.3;
            tools = {
              bash = false;
            };
            prompt = ''
              You are a technical writer. Create clear, comprehensive documentation.

              Focus on:

              - Clear explanations
              - Proper structure
              - Code examples
              - User-friendly language
            '';
          };
        };
      };
    };

    stylix.targets.opencode.enable = false;
  };
}
