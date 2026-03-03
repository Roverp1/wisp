{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.gaming;
in {
  options.wisp.gaming = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gaming module";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [prismlauncher];
  };
}
