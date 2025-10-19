{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.programs.swappy;
in {
  options.wisp.programs.swappy = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.wayland.enable;
      description = "Enable swappy module (for quick img editing)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.swappy = {
      enable = true;

      settings = {
        Default = {
          save_dir = "${config.xdg.userDirs.pictures}/ss";
          show_panel = true;
        };
      };
    };
  };
}
