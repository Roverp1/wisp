{
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    # build with `nix build .\#nixosConfigurations.aceso.config.system.build.isoImage`
    "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"
    ./../default.nix
  ];

  # Enable SSH for remote access
  services = {
    getty.autologinUser = lib.mkForce "aceso";

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "yes";
      };
    };
  };

  # Create rescue user with SSH access
  users.users.roverp = {
    isNormalUser = true;
    initialPassword = "rescue";
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.zsh;
  };

  # Home Manager for minimal shell setup
  home-manager = {
    users.roverp = {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
        ./../../modules/hm
      ];

      wisp = {
        wayland.enable = false;
        guiBundle.enable = false;

        programs = {
          kitty.enable = false;
          zenBrowser.enable = false;
        };
      };
    };
  };

  networking.hostName = "aceso";

  # Include debugging tools
  environment.systemPackages = with pkgs; [
    htop
    lshw
    pciutils
    usbutils
    smartmontools
    testdisk
    ddrescue
    rsync
    tcpdump
    nmap
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  wisp = {
    wayland.enable = false;
    boot.enable = false;
  };
}
