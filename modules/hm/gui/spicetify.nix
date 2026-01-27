{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.programs.spicetify;

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
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
    stylix.targets.spicetify = {
      enable = false;
    };

    programs.spicetify = {
      enable = true;

      # theme = spicePkgs.themes.text;
      theme = {
        name = "text";
        src = ../../../Configs/.config/spicetify/themes/text;

        # additonalCss = ''
        #   .player-controls__buttons,
        #   .main-nowPlayingBar-extraControls {
        #     opacity: 1;
        #   }
        # '';
      };

      colorScheme = "custom";
      customColorScheme = with config.lib.stylix.colors; {
        accent = base0B;
        accent-active = base0B;
        accent-inactive = base00;
        banner = base0B;
        border-active = base0B;
        border-inactive = base02;
        header = base03;
        highlight = base01;
        main = base00;
        notification = base0D;
        notification-error = base08;
        subtext = base04;
        text = base05;
      };

      alwaysEnableDevTools = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        keyboardShortcut
        beautifulLyrics
        # betterGenres
        # oneko
      ];

      wayland = config.wisp.wayland.enable;
    };
  };
}
