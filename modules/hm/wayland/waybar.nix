{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.wayland.waybar;

  waybarSettings = {
    mainBar = {
      position = "top";
      layer = "top";
      height = 20;

      modules-left = ["hyprland/workspaces" "hyprland/window"];
      modules-center = [];
      modules-right = ["network" "battery" "tray" "clock"];

      "hyprland/workspaces" = {
        format = "{id}";
        persistent-workspaces = {"*" = 10;};
      };

      "hyprland/window" = {
        separate-outputs = true;
      };

      clock = {
        format = "{:%b %e %I:%M %p}";
      };

      tray = {
        icon-size = 18;
        # spacing = 10;
      };

      battery = {
        format = "{capacity}%";
      };
    };
  };
in {
  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = waybarSettings;

      style = let
        base00 = config.lib.stylix.colors.withHashtag.base00;
        base01 = config.lib.stylix.colors.withHashtag.base01;
        base02 = config.lib.stylix.colors.withHashtag.base02;
        base03 = config.lib.stylix.colors.withHashtag.base03;
        base04 = config.lib.stylix.colors.withHashtag.base04;
        base05 = config.lib.stylix.colors.withHashtag.base05;
        base06 = config.lib.stylix.colors.withHashtag.base06;
        base07 = config.lib.stylix.colors.withHashtag.base07;
        base08 = config.lib.stylix.colors.withHashtag.base08;
        base09 = config.lib.stylix.colors.withHashtag.base09;
        base0A = config.lib.stylix.colors.withHashtag.base0A;
        base0B = config.lib.stylix.colors.withHashtag.base0B;
        base0C = config.lib.stylix.colors.withHashtag.base0C;
        base0D = config.lib.stylix.colors.withHashtag.base0D;
        base0E = config.lib.stylix.colors.withHashtag.base0E;
      in ''
        * {
          font-family: "JetBrainsMono NF Regular";
          font-size: 16px;
          border-radius: 0;
        }

        window#waybar {
          color: ${base05};
          background-color: ${base01};
        }

        .modules-left, .modules-right {
          background-color: ${base00};
          padding: 0;
        }

        #workspaces button {
          border: none;
          box-shadow: none;
          background: transparent;

          padding: 0 8px;
          min-width: 1px;

          color: ${base04};
        }

        #workspaces button.active {
          color: ${base00};
          background-color: ${base0D};
        }

        #window {
          color: ${base00};
          background-color: ${base0D};
        }

        window#waybar.empty #window {
          color: transparent;
          background-color: transparent;
        }

        #network,
        #battery,
        #clock {
          padding: 0 10px;

          color: ${base05};
        }

        #battery.critical {
          color: ${base08};
        }

        #network.disconnected {
          color: ${base03};
        }

        #tray {
          padding: 0 8px;
        }
      '';
    };
  };
}
