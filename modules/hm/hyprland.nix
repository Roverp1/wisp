{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.hyprland;
in {
  options.wisp.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Hyprland module";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;

      extraConfig = ''
        ${builtins.readFile ./../../Configs/.config/hypr/general.conf}
        ${builtins.readFile ./../../Configs/.config/hypr/keybinds.conf}
        ${builtins.readFile ./../../Configs/.config/hypr/windowrules.conf}
      '';
    };
  };
}
