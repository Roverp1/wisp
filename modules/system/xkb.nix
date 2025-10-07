{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.xkb;
in {
  options.wisp.xkb = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable xkb module";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.xkb = {
      extraLayouts = {
        rpd = {
          description = "Polish (Real Programmers Dvorak)";
          languages = ["pol"];
          symbolsFile = ../../Configs/.config/xkb/rpd;
        };
      };
    };
  };
}
