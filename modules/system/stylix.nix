{
  lib,
  pkgs,
  ...
}: let
  selectTheme = "ayu-dark";

  themes = import ./themes/default.nix {inherit pkgs;};
  theme = themes.${selectTheme};
in {
  stylix = {
    enable = true;

    # targets = {
    #   gnome.enable = false;
    # };

    # cursor = {
    #   package = pkgs.bibata-cursors;
    #   name = "Bibata-Modern-Classic";
    #   size = 24;
    # };

    base16Scheme = theme.base16Scheme;
    # image = theme.wallpaper;
    # polarity = theme.polarity;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono NF Regular";
      };
    };
  };
}
