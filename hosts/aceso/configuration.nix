{
  inputs,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    ./../../modules/system
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        userPkgs = import inputs.nixpkgs-unstable {
          inherit (prev) system;
          config.allowUnfree = true;
        };
      })
    ];
  };

  # Disable GUI components
  wisp.wayland.enable = false;

  # Enable SSH for remote access
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  # Create rescue user with SSH access
  users.users.aceso = {
    isNormalUser = true;
    initialPassword = "rescue";
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.zsh;
  };

  # Set root password for emergency access
  users.users.root.initialPassword = "root";

  # Home Manager for minimal shell setup
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.aceso = {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
        ./../../modules/hm
      ];

      wisp.wayland.enable = false;
      wisp.programs = {
        kitty.enable = false;
        zenBrowser.enable = false;
      };
    };
  };

  networking.hostName = "aceso";
  networking.wireless.enable = false; # Use NetworkManager instead
  networking.networkmanager.enable = true;

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
  system.stateVersion = "25.05";
}
