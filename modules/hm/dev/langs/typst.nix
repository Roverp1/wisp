{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.langs.typst;
in {
  options.wisp.langs.typst = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable typst language module";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [typst tinymist];
  };
}
