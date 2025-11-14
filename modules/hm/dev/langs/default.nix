{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.langs;
in {
  imports = [
    ./typst.nix
    ./css.nix
  ];

  options.wisp.langs = {
    frontend = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable frontend langs bundle (css, emmet, ts...)";
    };
  };

  config = lib.mkIf cfg.frontend {
    home.packages = with pkgs; [emmet-language-server prettierd];
  };
}
