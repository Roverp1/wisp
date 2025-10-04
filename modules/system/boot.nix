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
      default = false;
      description = "Whether to use systemd boot";
    };

    grub.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to use grub boot (enabled by default if systemdBoot is disabled)";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.systemdBoot.enable && cfg.grub.enable);
        message = "wisp.boot: Cannot enable both systemd-boot and GRUB";
      }

      {
        assertion = cfg.systemdBoot.enable || cfg.grub.enable;
        message = "wisp.boot: Must enable either systemd-boot or GRUB";
      }
    ];

    boot.loader = lib.mkMerge [
      (
        lib.mkIf cfg.systemdBoot.enable {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        }
      )

      (
        lib.mkIf cfg.grub.enable {
          grub = {
            enable = true;
            device = "nodev";
            efiSupport = true;
            enableCryptodisk = true;
          };

          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };
        }
      )
    ];
  };
}
