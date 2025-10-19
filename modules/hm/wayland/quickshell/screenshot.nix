{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.quickshell.screenshot;

  screenshot-script = pkgs.writeShellScriptBin "qs-screenshot" ''
    if pgrep -f "quickshell.*screenshot.qml" > /dev/null; then
      echo "Screenshot tool already running"
      exit 0
    fi

    quickshell -p ${config.xdg.configHome}/quickshell/screenshot.qml
  '';
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
      screenshot-script

      grim
      imagemagick
    ];

    wisp.programs.swappy.enable = true;

    xdg.configFile."quickshell/screenshot.qml".source = ./../../../../Configs/.config/quickshell/screenshot.qml;
  };
}
