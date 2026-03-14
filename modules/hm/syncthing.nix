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
      default = config.wisp.guiBundle.enable && !config.wisp.genericLinux; # change to allow without gui?
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
          "spesn" = {
            id = "MKRVTRT-FYGKE65-H6FOPMK-54UUD3V-ROVNRGR-663YTXO-32DNGCI-ZZXZBAL"; # private?
            name = "spesn";
          };
          "iris" = {
            id = "MWSDPRV-JSNLUMK-3RNTMJV-BIHSJTM-MPP76G2-7QPD4EX-OH5DRDN-5CAPBAP";
            name = "iris";
          };
        };

        folders = let
          syncthingFolder = "${config.xdg.dataHome}/syncthing";
        in {
          "main" = {
            enable = true;

            id = "pqlkx-xq3hi";
            path = "${syncthingFolder}/main";
            devices = ["spesn" "iris"];
            type = "sendreceive";
            versioning = {
              type = "simple";
              params.keep = "5";
            };
          };

          "astercraft-private" = {
            enable = true;

            id = "qhwhm-oddda";
            path = "${config.home.homeDirectory}/Documents/AsterCraft-private";
            devices = ["spesn" "iris"];
            type = "sendreceive";
            versioning = {
              type = "simple";
              params.keep = "1";
            };
          };

          "readera-backups" = {
            enable = true;

            id = "hxq17-h3042";
            path = "${config.home.homeDirectory}/code/readera-anki/readera-backups";
            devices = ["spesn" "iris"];
            type = "receiveonly";
          };

          "ankiera-result" = {
            enable = true;

            id = "nrjac-fswf2";
            path = "${config.home.homeDirectory}/code/readera-anki/result";
            devices = ["spesn" "iris"];
            type = "sendonly";
          };
        };

        options = {
          localAnnounceEnabled = true;
          urAccepted = -1;
        };
      };
    };
  };
}
