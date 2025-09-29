{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.system;
in {
  options.wisp.system = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable system module";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dbus # inter-process communication daemon
      upower # power management/battery status daemon
    ];

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji

      nerd-fonts.jetbrains-mono
    ];

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

    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      zsh.enable = true;
    };

    services = {
      dbus.enable = true;
      upower.enable = true;
      openssh.enable = true;
      libinput.enable = true;
      udisks2 = {
        enable = true;
        mountOnMedia = true;
      };
      gvfs.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    nix = {
      settings.experimental-features = ["nix-command" "flakes"];

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than +5";
      };
    };
  };
}
