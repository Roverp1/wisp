{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.wayland.waybar;
in {
  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        mainBar = {
          position = "top";
          layer = "top";
          height = 25;

          modules-left = ["hyprland/workspaces" "hyprland/window"];
          modules-center = [];
          modules-right = ["network" "battery" "tray" "clock"];

          "hyprland/window" = {
            separate-outputs = true;
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

      style = ./../../../Configs/.config/waybar/style.css;
    };
  };
}
