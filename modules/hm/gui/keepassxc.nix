{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.programs.keepassxc;
in {
  options.wisp.programs.keepassxc = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.guiBundle.enable;
      description = "Enable keepassxc module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.keepassxc = {
      enable = true;

      settings = {
        Browser = {
          Enabled = true;
          UpdateBinaryPath = false;
        };

        GUI.TrayIconAppearance = "monochrome-light";

        PasswordGenerator = {
          AdvancedMode = true;
          Length = 20;
          Braces = true;
          Dashes = true;
          Logograms = true;
          Math = true;
          Punctuation = true;
          Quotes = true;
        };

        Security.ClearClipboardTimeout = 120;
      };
    };
  };
}
