{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.quickshell.screenshot;
in {
  options.wisp.quickshell.screenshot = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.quickshell.enable;
      description = "Enale screenshot script module";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      imagemagick
      swappy
    ];

    xdg.configFile."quickshell/screenshot.qml".source = ./../../../../Configs/.config/quickshell/screenshot.qml;
  };
}
