{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.programs.bat;
in {
  options.wisp.programs.bat = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.cliBundle.optional;
      description = "Enable bat module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
    };
  };
}
