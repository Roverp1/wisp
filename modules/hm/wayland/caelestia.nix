{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.wayland.caelestia;
in {
  options.wisp.wayland.caelestia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Caelestia desktop shell";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.caelestia = {
      enable = true;
      cli.enable = true;
    };

    wisp.wayland.waybar.enable = lib.mkForce false;
    wisp.quickshell.screenshot.enable = lib.mkForce false;
  };
}
