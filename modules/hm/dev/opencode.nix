{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.roverp.programs.opencode;

  playwrightMcpConfig = pkgs.writeText "playwright-mcp.json" (builtins.toJSON {
    browser = {
      browserName = "chromium";

      launchOptions = {
        executablePath = "${pkgs.chromium}/bin/chromium";
        args = [
          "--enable-features=WebMachineLearningNeuralNetwork,ExperimentalWebMachineLearningNeuralNetwork"
        ];
      };
    };
  });
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

      context =
        # markdown
        ''
          # CLI tools
          - when user provides GitHub link:
            - use gh CLI when possible to fetch information
            - if gh doesnt provide required functionality for fetching informaion - use `api.github.com`/`raw.github.com` endpoints

          - when task requires specific cli tool, but user's machine doesnt have it installed:
            - inform user what required tools are missing, and suggest using `nix-shell -p` to temporarly install them

          ${builtins.readFile ../../../Configs/.config/opencode/rules/writing-guidelines.md}
        '';
      # ${builtins.readFile ../../../Configs/.config/opencode/rules/pr-guidelines.md}

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

        agent = {
          explore.model = "openai/gpt-6-luna";
          general.model = "openai/gpt-6.1-sol";

          "general-cheap" = {
            description = "Lower-cost general-purpose agent for researching relatively simple-medidum questions and executing multi-step tasks. Use this agent to execute multiple units of work in parallel.";

            mode = "subagent";
            model = "openai/gpt-6-luna";
            steps = 100;

            permission = {
              todowrite = "deny";
              task = "deny";
            };

            prompt = ''
              Handle the described tasks.
              If the work needs broad architectural judgment, difficult debugging, or a
              consequential tradeoff, report the evidence and unresolved
              decision to the parent agent.
            '';
          };
        };

        autoupdate = false;

        lsp = {
          # doesnt work?
          "qmlls" = {
            command = ["qmlls" "-E"];
            extensions = [".qml"];
          };
        };

        mcp = {
          nixos = {
            type = "local";
            command = [
              "nix"
              "run"
              "github:utensils/mcp-nixos"
              "--"
            ];
            enabled = true;
          };

          # "Astro docs" = {
          #   type = "remote";
          #   url = "https://mcp.docs.astro.build/mcp";
          #   enabled = true;
          # };
          #
          # mantine = {
          #   type = "local";
          #   command = [
          #     "bunx"
          #     "-y"
          #     "@mantine/mcp-server"
          #   ];
          #   environment = {
          #     MANTINE_MCP_DATA_URL = "https://mantine.dev/mcp";
          #   };
          #   enabled = true;
          # };

          playwright = {
            type = "local";
            command = [
              "${pkgs.playwright-mcp}/bin/playwright-mcp"
              "--config"
              "${playwrightMcpConfig}"
            ];
            environment = {
              PLAYWRIGHT_MCP_ISOLATED = "1";
            };
            enabled = true;
          };
        };
      };
    };

    stylix.targets.opencode.enable = false;
  };
}
