{
  config,
  lib,
  ...
}: {
  imports = [
    ./hyprland.nix
    ./waybar.nix
  ];

  options.wisp.wayland = {
    hyprland.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.wayland.enable;
      description = "Enable hyprland module";
    };

    waybar.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.wayland.hyprland.enable;
      description = "Enable waybar module";
    };
  };
}
