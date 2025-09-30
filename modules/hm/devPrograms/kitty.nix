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

      settings = {
        confirm_os_window_close = 3;
        enable_audio_bell = true;

        cursor_shape = "block";
        mouse_hide_wait = 2.0;
        cursor_blink_interval = 0;

        background_opacity = 0.9;
      };

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
