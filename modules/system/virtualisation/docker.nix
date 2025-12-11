{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.virtualisation.docker;
in {
  options.wisp.virtualisation.docker = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.virtualisation.enable;
      description = "Enable Docker with docker-compose";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      # enableOnBoot = true;

      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    users.users.roverp.extraGroups = ["docker"];
  };
}
