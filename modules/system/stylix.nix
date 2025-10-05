{
  lib,
  pkgs,
  ...
}: let
  selectTheme = "gruvbox-dark-hard";

  themes = import ./themes/default.nix {inherit pkgs;};
  theme = themes.${selectTheme};
in {
  stylix = {
    enable = true;

    opacity.popups = 1.0;

    base16Scheme = theme.base16Scheme;
    image = theme.wallpaper;
    polarity = theme.polarity;

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    fonts = {
      sizes = {
        applications = 11;
        desktop = 11;
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono NF Regular";
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
  };
}
