{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.sanBundle;
in {
  options.wisp.sanBundle = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable SAN (Social Science Academy) bundle (remove as soon as possible)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      scilab-bin
      teams-for-linux
    ];
  };
}
