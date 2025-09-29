{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.wayland.hyprland;
in {
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;

      extraConfig = ''
        ${builtins.readFile ./../../../Configs/.config/hypr/general.conf}
        ${builtins.readFile ./../../../Configs/.config/hypr/keybinds.conf}
        ${builtins.readFile ./../../../Configs/.config/hypr/windowrules.conf}
      '';
    };
  };
}
