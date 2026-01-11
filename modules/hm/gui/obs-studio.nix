{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.programs.obs-studio;
in {
  options.wisp.programs.obs-studio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.guiBundle.enable;
      description = "Enable obs-studio module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
    };
  };
}
