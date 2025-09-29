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

      "hyprland/window" = {
        # separate-outputs = true;
        persistent-workspaces = {"*" = 10;};
      };

      clock = {
        format = "{:%b %e %I:%M %p}";
      };

      tray = {
        icon-size = 18;
        spacing = 10;
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

      style = ./../../../Configs/.config/waybar/style.css;
    };
  };
}
