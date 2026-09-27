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
          "spes" = {
            id = "H45XOQU-R7ILWTU-7WB6VDC-2NFR6OR-VIZ4KCW-G6XQD6Y-YP5TYU3-5URORQX"; # private?
            name = "spes";
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
            devices = ["spes" "iris"];
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
            devices = ["spes" "iris"];
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
            devices = ["iris"];
            type = "receiveonly";
          };

          "ankiera-result" = {
            enable = true;

            id = "nrjac-fswf2";
            path = "${config.home.homeDirectory}/code/readera-anki/result";
            devices = ["iris"];
            type = "sendonly";
          };

          "polish-course-cards" = {
            enable = true;

            id = "jnagw-evdsm";
            path = "${config.home.homeDirectory}/Documents/polish/out";
            devices = ["iris"];
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
