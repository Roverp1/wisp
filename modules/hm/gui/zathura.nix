{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.programs.zathura;
in {
  options.wisp.programs.zathura = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.guiBundle.enable;
      description = "Enable zathura module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zathura = {
      enable = true;
    };
  };
}
