{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./../default.nix

    inputs.disko.nixosModules.disko
    ./disko-config.nix

    ./hardware-configuration.nix

    # Hardware Configuration - Uncomment lines that match your hardware
    # Run `lshw -short` or `lspci` to identify your hardware

    # GPU Configuration (choose one):
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia # NVIDIA
    # inputs.nixos-hardware.nixosModules.common-gpu-amd # AMD

    # CPU Configuration (choose one):
    # inputs.nixos-hardware.nixosModules.common-cpu-amd # AMD CPUs
    inputs.nixos-hardware.nixosModules.common-cpu-intel # Intel CPUs

    # Additional Hardware Modules - Uncomment based on your system type:
    # inputs.nixos-hardware.nixosModules.common-hidpi # High-DPI displays
    inputs.nixos-hardware.nixosModules.common-pc-laptop # Laptops
    inputs.nixos-hardware.nixosModules.common-pc-ssd # SSD storage
  ];

  # If enabling NVIDIA, you will be prompted to configure hardware.nvidia
  # hardware.nvidia = {
  #   open = true; # For newer cards, you may want open drivers
  #   prime = { # For hybrid graphics (laptops), configure PRIME:
  #     amdBusId = "PCI:0:2:0"; # Run `lspci | grep VGA` to get correct bus IDs
  #     intelBusId = "PCI:0:2:0"; # if you have intel graphics
  #     nvidiaBusId = "PCI:1:0:0";
  #     offload.enable = false; # Or disable PRIME offloading if you don't care
  #   };
  # };

  # Home Manager Configuration
  home-manager = {
    # This must match the username you define in users.users below
    users."roverp" = {...}: {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
        ./../../modules/hm
        ./hm-overrides.nix
      ];
    };
  };

  # User Account Setup - REQUIRED: Change "hydenix" to your desired username (must match above)
  users.users.roverp = {
    isNormalUser = true;
    initialPassword = "hydenix"; # SECURITY: Change this password after first login with `passwd`
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ]; # User groups (determines permissions)
    shell = pkgs.zsh;
  };

  networking.hostName = "wisp-vm";
  time.timeZone = "Europe/Warsaw";

  services.qemuGuest.enable = true;

  wisp.boot.systemdBoot.enable = true;
}
