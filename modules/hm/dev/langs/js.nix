{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.langs.js;
in {
  options.wisp.langs.js = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable javascript language support";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bun
      nodejs
      typescript-language-server
      prettierd
    ];
  };
}
