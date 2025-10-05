{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.programs.syncthing;
in {
  options.wisp.programs.syncthing = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.guiBundle.enable; # change this?
      description = "Enable syncthing module";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;

      overrideDevices = true;
      overrideFolders = true;

      settings = {
        devices = {
          "Matrixx_spesn" = {
            id = "MKRVTRT-FYGKE65-H6FOPMK-54UUD3V-ROVNRGR-663YTXO-32DNGCI-ZZXZBAL";
            name = "Personal android phone";
          };
        };

        folders = let
          syncthingFolder = "${config.xdg.dataHome}/syncthing";
        in {
          "main" = {
            enable = true;

            id = "pqlkx-xq3hi";
            path = "${syncthingFolder}/main";
            devices = ["Matrixx_spesn"];
            type = "sendreceive";
            versioning = {
              type = "simple";
              params.keep = "5";
            };
          };
        };

        options = {
          localAnnounceEnabled = true;
        };
      };
    };
  };
}
