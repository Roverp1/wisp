{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.programs.rofi;
in {
  options.wisp.programs.rofi = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.guiBundle.enable;
      description = "Enable rofi module";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [tela-icon-theme];

    programs.rofi = {
      enable = true;

      location = "top";

      extraConfig = {
        modi = "drun";
        display-drun = "󱄅";
        drun-display-format = "{name}";
        show-icons = true;
        icon-theme = "Tela-black";
      };
    };
  };
}
