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
    ./javascript.nix
    ./sh.nix
    ./python.nix
    ./c.nix
  ];

  options.wisp.langs = {
    frontend = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable frontend langs bundle (css, emmet, ts...)";
    };

    optional = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable optional lang support";
    };
  };

  config = lib.mkIf cfg.frontend {
    home.packages = with pkgs; [emmet-language-server prettierd];
  };
}
