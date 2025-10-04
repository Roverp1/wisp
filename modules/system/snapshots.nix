{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.btrbk;
in {
  options.wisp = {
    btrbk.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable btrbk snapshots for btrfs";
    };
  };

  config = lib.mkIf cfg.enable {
    services.btrbk.instances = {
      "home-snapshots" = {
        onCalendar = "daily";
      };
    };
  };
}
