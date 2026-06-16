{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.wayland.caelestia;
  colors = config.lib.stylix.colors;

  schemeJson = builtins.toJSON {
    name = "stylix";
    mode = "dark";
    flavour = "base16";
    colours = {
      # Structural Core
      background = colors.base00;
      surface = colors.base00;
      surfaceDim = colors.base00;
      surfaceContainerLowest = colors.base00;
      surfaceBright = colors.base01;
      surfaceContainerLow = colors.base01;
      surfaceContainer = colors.base01;
      surfaceContainerHigh = colors.base02;
      surfaceContainerHighest = colors.base02;

      # Readable Layer
      onBackground = colors.base05;
      onSurface = colors.base05;
      inverseSurface = colors.base05;
      inverseOnSurface = colors.base00;
      onSurfaceVariant = colors.base04;

      # Borders & Shadows
      outline = colors.base03;
      outlineVariant = colors.base02;
      shadow = "000000";
      scrim = "000000";

      # Primary (base0D - Blue - Functions, Headings)
      primary = colors.base0D;
      onPrimary = colors.base00;
      primaryContainer = colors.base02;
      onPrimaryContainer = colors.base0D;
      inversePrimary = colors.base0D;
      surfaceTint = colors.base0D;
      primaryFixed = colors.base0D;
      primaryFixedDim = colors.base0D;
      onPrimaryFixed = colors.base00;
      onPrimaryFixedVariant = colors.base00;

      # Secondary (base09 - Magenta - Keywords, Storage)
      secondary = colors.base09;
      onSecondary = colors.base00;
      secondaryContainer = colors.base02;
      onSecondaryContainer = colors.base09;
      secondaryFixed = colors.base09;
      secondaryFixedDim = colors.base09;
      onSecondaryFixed = colors.base00;
      onSecondaryFixedVariant = colors.base00;

      # Tertiary (base0C - Cyan - Strings, Escapes)
      tertiary = colors.base0C;
      onTertiary = colors.base00;
      tertiaryContainer = colors.base02;
      onTertiaryContainer = colors.base0C;
      tertiaryFixed = colors.base0C;
      tertiaryFixedDim = colors.base0C;
      onTertiaryFixed = colors.base00;
      onTertiaryFixedVariant = colors.base00;

      # Error (base08 - Red)
      error = colors.base08;
      onError = colors.base00;
      errorContainer = colors.base02;
      onErrorContainer = colors.base08;

      # Success (base0B - Green)
      success = colors.base0B;
      onSuccess = colors.base00;
      successContainer = colors.base02;
      onSuccessContainer = colors.base0B;

      # Terminals
      term0 = colors.base00;
      term1 = colors.base08;
      term2 = colors.base0B;
      term3 = colors.base0A;
      term4 = colors.base0D;
      term5 = colors.base0E;
      term6 = colors.base0C;
      term7 = colors.base05;
      term8 = colors.base03;
      term9 = colors.base08;
      term10 = colors.base0B;
      term11 = colors.base0A;
      term12 = colors.base0D;
      term13 = colors.base0E;
      term14 = colors.base0C;
      term15 = colors.base07;
    };
  };

  schemeFile = pkgs.writeText "caelestia-stylix-scheme.json" schemeJson;
in {
  options.wisp.wayland.caelestia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Caelestia desktop shell";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.caelestia = {
      enable = true;
      cli.enable = true;
    };

    wisp.wayland.waybar.enable = lib.mkForce false;
    wisp.quickshell.screenshot.enable = lib.mkForce false;

    home.activation.caelestia-stylix-theme = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run mkdir -p "$HOME/.local/state/caelestia"
      run cp -f ${schemeFile} "$HOME/.local/state/caelestia/scheme.json"
      run chmod 644 "$HOME/.local/state/caelestia/scheme.json"
    '';
  };
}
