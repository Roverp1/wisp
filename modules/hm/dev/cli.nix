{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.cliBundle;
in {
  options.wisp.cliBundle = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable cli bundle (programs used in terminal)";
    };

    optional = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable optional cli bundle (minor qol imrovers)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        gcc
        nodejs

        ripgrep
        fd
      ]
      ++ lib.optionals cfg.optional [gh];
  };
}
