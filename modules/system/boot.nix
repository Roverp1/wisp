{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.wisp.boot;
in {
  options.wisp.boot = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable boot module";
    };

    systemdBoot.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use systemd boot";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
