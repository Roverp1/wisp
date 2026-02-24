{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.langs.python;
in {
  options.wisp.langs.python = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable python language support";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [python];
  };
}
