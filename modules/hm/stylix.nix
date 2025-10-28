{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.stylix;

  selectTheme = "gruvbox-dark-hard";
  themePath = themeName: "${pkgs.base16-schemes}/share/themes/${themeName}.yaml";

  themes = {
    gruvbox-dark-hard = {
      base16Scheme = themePath "gruvbox-dark-hard";
      wallpaper = ../system/themes/wallpapers/wallhaven-3lp2md.jpg;
      polarity = "dark";
    };
  };

  theme = themes.${selectTheme};
in {
  options.wisp.stylix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.genericLinux;
      description = "Enable stylix theming for home-manager";
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;

      base16Scheme = theme.base16Scheme;
      polarity = theme.polarity;

      image = theme.wallpaper;

      opacity.popups = 1.0;

      fonts = {
        sizes = {
          applications = 11;
          desktop = 11;
          terminal = 11;
        };

        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono NF Regular";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };
    };

    # Install fonts via home.packages for generic Linux
    home.packages = lib.mkIf config.wisp.genericLinux [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.noto-fonts-emoji
      pkgs.bibata-cursors
    ];
  };
}
