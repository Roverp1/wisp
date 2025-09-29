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
    };
  };
}
