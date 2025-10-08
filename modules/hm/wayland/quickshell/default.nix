{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.quickshell;
in {
  imports = [
    ./screenshot.nix
  ];

  options.wisp.quickshell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.wayland.hyprland.enable;
      description = "Enable quickshell module (responsible for scripting & desktop ui)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs.userPkgs; [quickshell];
  };
}
