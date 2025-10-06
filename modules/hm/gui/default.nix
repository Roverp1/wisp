{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.guiBundle;
in {
  imports = [
    ./keepassxc.nix
    ./rofi.nix
    ./spicetify.nix
  ];

  options.wisp.guiBundle = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.wayland.enable;
      description = "Enable GUI bundle";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vesktop
      telegram-desktop
    ];
  };
}
