{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.programs.spicetify;

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in {
  imports = [inputs.spicetify-nix.homeManagerModules.spicetify];

  options.wisp.programs.spicetify = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.guiBundle.enable;
      description = "Enable spicetify module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.spicetify = {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        beautifulLyrics
        keyboardShortcut
        # betterGenres
        # oneko
      ];

      wayland = config.wisp.wayland.enable;
    };
  };
}
