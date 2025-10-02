{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.wisp.programs.zenBrowser;
in {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  options.wisp.programs.zenBrowser = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable zen-browser module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;

      policies = {
        DisableAppUpdate = true;

        DisableTelemetry = true;
        EnableTrackingProtection = {
          Value = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };

    stylix.targets.zen-browser.profileNames = ["default"];
  };
}
