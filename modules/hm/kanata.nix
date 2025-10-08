{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.kanata;
in {
  options.wisp.kanata = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable kanata module (no autostart)";
    };
  };

  config = lib.mkIf {
    home.packages = [pkgs.kanata];

    home.file.".config/kanata/kanata.kbd".source = ./../../Configs/.config/kanata/kanata.kbd;
  };
}
