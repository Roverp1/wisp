{
  config,
  lib,
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
}
