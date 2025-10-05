{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.wisp.programs.zenBrowser;
in {
  imports = [
    inputs.zen-browser.homeModules.beta
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

      profiles.default.isDefault = true;

      policies = {
        DisableAppUpdate = true;

        DisableTelemetry = true;
        EnableTrackingProtection = {
          Value = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        ExtensionSettings = let
          vimiumId = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
          oneTabId = "extension@one-tab.com";
          autoTabDiscardId = "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}";
        in {
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            pinned = true;
          };

          "${vimiumId}" = {
            install_url = "https://addons.mozilla.org/downloads/latest/vimium-ff/latest.xpi";
            installation_mode = "force_installed";
            pinned = true;
          };

          "${oneTabId}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/onetab/latest.xpi";
            installation_mode = "force_installed";
            pinned = true;
          };

          "${autoTabDiscardId}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/auto-tab-discard/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };

    stylix.targets.zen-browser.enable = false;
    # stylix.targets.zen-browser.profileNames = ["default"];
  };
}
