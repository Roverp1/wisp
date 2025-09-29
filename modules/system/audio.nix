{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.audio;
in {
  options.wisp.audio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable audio and bluetooth module";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [pavucontrol playerctl];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    services = {
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        wireplumber.enable = true;
      };
    };
  };
}
