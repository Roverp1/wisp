{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.langs.css;
in {
  options.wisp.langs.css = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.langs.frontend;
      description = "Enable css lang support";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      emmet-language-server
      vscode-langservers-extracted
      prettierd
    ];
  };
}
