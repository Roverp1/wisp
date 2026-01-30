{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.transmission;

  magnet-handler = pkgs.writeShellScript "transmission-magnet-handler" ''
    # Takes magnet link as $1
    # Opens kitty with tremc and magnet link
    ${pkgs.transmission_4}/bin/transmission-remote localhost:9091 -a "$1"

    ${pkgs.kitty}/bin/kitty --class tremc-magnet \
      -e ${pkgs.tremc}/bin/tremc --connect localhost:9091
  '';
in {
  options.wisp.transmission = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable transmission module (requires system's wisp.transmission.enable = true;)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [tremc];

    home.activation = {
      createTorrentDirs =
        lib.hm.dag.entryAfter ["writeBoundary"]
        # bash
        ''
          mkdir -p "${config.home.homeDirectory}/torrents/watch"
          mkdir -p "${config.home.homeDirectory}/torrents/incomplete"
        '';
    };

    xdg.desktopEntries.transmission-magnet = {
      name = "Transmission (Magnet Link)";
      genericName = "BitTorrent Client";
      comment = "Handle magnet links with tremc";
      exec = "${magnet-handler} %U";
      icon = "transmission";
      terminal = false;
      categories = ["Network" "FileTransfer" "P2P"];
      mimeType = ["x-scheme-handler/magnet"];
      noDisplay = true;
    };
  };
}
