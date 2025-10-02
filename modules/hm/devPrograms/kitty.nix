{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.programs.kitty;
in {
  options.wisp.programs.kitty = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable kitty module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      font = {
        name = "JetBrainsMono NF Regular";
        size = 14;
      };

      settings = let
        base00 = config.lib.stylix.colors.withHashtag.base00;
        base01 = config.lib.stylix.colors.withHashtag.base01;
        base02 = config.lib.stylix.colors.withHashtag.base02;
        base03 = config.lib.stylix.colors.withHashtag.base03;
        base04 = config.lib.stylix.colors.withHashtag.base04;
        base05 = config.lib.stylix.colors.withHashtag.base05;
        base06 = config.lib.stylix.colors.withHashtag.base06;
        base07 = config.lib.stylix.colors.withHashtag.base07;
        base08 = config.lib.stylix.colors.withHashtag.base08;
        base09 = config.lib.stylix.colors.withHashtag.base09;
        base0A = config.lib.stylix.colors.withHashtag.base0A;
        base0B = config.lib.stylix.colors.withHashtag.base0B;
        base0C = config.lib.stylix.colors.withHashtag.base0C;
        base0D = config.lib.stylix.colors.withHashtag.base0D;
        base0E = config.lib.stylix.colors.withHashtag.base0E;
        base0F = config.lib.stylix.colors.withHashtag.base0F;

        theme = {
          background = base00;
          foreground = base05;
          selection_background = base03;
          selection_foreground = base05;

          cursor = base05;
          cursor_text_color = base00;

          active_border_color = base03;
          inactive_border_color = base01;

          # OS Window titlebar colors
          wayland_titlebar_color = base00;
          macos_titlebar_color = base00;

          # Tab bar colors
          active_tab_background = base00;
          active_tab_foreground = base05;
          inactive_tab_background = base01;
          inactive_tab_foreground = base04;
          tab_bar_background = base01;

          color0 = base00;
          color1 = base08;
          color2 = base0B;
          color3 = base0A;
          color4 = base0D;
          color5 = base0E;
          color6 = base0C;
          color7 = base05;

          color8 = base02;
          color9 = base08;
          color10 = base0B;
          color11 = base0A;
          color12 = base0D;
          color13 = base0E;
          color14 = base0C;
          color15 = base07;

          color16 = base09;
          color17 = base0F;
          color18 = base01;
          color19 = base02;
          color20 = base04;
          color21 = base06;
        };
      in
        {
          confirm_os_window_close = 3;
          enable_audio_bell = true;

          cursor_shape = "block";
          mouse_hide_wait = 2.0;
          cursor_blink_interval = 0;

          background_opacity = 0.9;
        }
        // theme;

      keybindings = {
        "ctrl+shift+h" = "no_op";
        "ctrl+shift+l" = "no_op";
        "ctrl+alt+h" = "no_op";
        "ctrl+alt+l" = "no_op";
        "ctrl+alt+j" = "no_op";
        "ctrl+alt+k" = "no_op";

        "ctrl+shift+minus" = "no_op";
        "ctrl+shift+equal" = "no_op";

        "ctrl+shift+period" = "increase_font_size";
        "ctrl+shift+comma" = "decrease_font_size";
      };
    };
  };
}
