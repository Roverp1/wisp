{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.langs.sh;
in {
  options.wisp.langs.sh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.langs.optional;
      description = "Enable shell language support";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bash-language-server
      shfmt
    ];
  };
}
