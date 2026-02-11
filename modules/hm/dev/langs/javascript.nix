{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.langs.javascript;
in {
  options.wisp.langs.javascript = {
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
