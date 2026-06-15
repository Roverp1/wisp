{
  config,
  lib,
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

      context = ''
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
      tui = {
        theme = "system";

        keybinds = {
          leader = "alt+b";
        };
        scroll_acceleration = {
          enabled = false;
        };
      };

      settings = {
        default_agent = "plan";

        lsp = {
          # doesnt work?
          "qmlls" = {
            command = ["qmlls" "-E"];
            extensions = [".qml"];
          };
        };
      };
    };

    stylix.targets.opencode.enable = false;
  };
}
