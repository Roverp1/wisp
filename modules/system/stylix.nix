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

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    base16Scheme = theme.base16Scheme;
    image = theme.wallpaper;
    polarity = theme.polarity;

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
  };
}
