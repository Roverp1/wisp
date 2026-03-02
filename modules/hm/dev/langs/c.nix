{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.langs.c;
in {
  options.wisp.langs.c = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.langs.optional;
      description = "Enable c language support";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gcc
      clang-tools
    ];
  };
}
