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

      theme = {
        name = "text";
        src = "${spicePkgs.themes.text.src}";

        additionalCss = ''
          :root {
            --display-tracklist-image: block; /* none | block */
            --font-size-lyrics: 20px;
          }

          .player-controls__buttons,
          .main-nowPlayingBar-extraControls {
            opacity: 1;
          }
        '';
      };

      colorScheme = "custom";
      customColorScheme = with config.lib.stylix.colors; {
        # Backgrounds
        main = base00; # Default Background
        highlight = base02; # Selection Background (semantic match!)

        # Foregrounds
        text = base05; # Default Foreground, Caret
        subtext = base04; # Dark Foreground (status bars)

        # Primary accent (interactive elements)
        accent = base0D; # Blue - Functions/Headings (primary UI actions)
        accent-active = base0D; # Same for consistency
        accent-inactive = base00; # Inactive state (background)

        # UI structure
        border-active = base0D; # Match primary accent
        border-inactive = base03; # Comments/Invisibles (subtle)
        header = base04; # Dark Foreground (better visibility than base03)

        # Prominent elements
        banner = base0D; # Match primary accent (or base0E for emphasis?)

        # Notifications
        notification = base0C; # Cyan - Support/Info (distinct from primary)
        notification-error = base08; # Red - Errors/Deleted
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
