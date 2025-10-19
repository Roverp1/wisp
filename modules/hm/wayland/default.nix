{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.wayland;
in {
  imports = [
    ./hyprland.nix
    ./waybar.nix

    ./quickshell

    ./swappy.nix
  ];

  options.wisp.wayland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable home-manager wayland module (system's wayland module can be enabled for better integration)";
    };

    hyprland.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.wayland.enable;
      description = "Enable home-manager hyprland module (system's hyprland module can be enabled for better integration)";
    };

    waybar.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.wayland.hyprland.enable;
      description = "Enable waybar module";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard
    ];
  };
}
