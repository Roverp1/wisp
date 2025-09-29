{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.wayland;
in {
  options.wisp.wayland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable wayland module";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.variables = {
      NIXOS_OZONE_WL = "1";
    };

    programs.hyprland = {
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      enable = true;
      withUWSM = false;
    };
  };
}
