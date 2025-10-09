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
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gcc
      nodejs

      ripgrep
      fd
    ];
  };
}
