{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./../default.nix

    inputs.nixos-hardware.nixosModules.asus-fx506hm

    inputs.disko.nixosModules.disko
    # (import ./disko.nix {device = "/dev/disk/by-id/nvme-KINGSTON_SKC3000S1024G_50026B7686760CFD";})
    ./disko-config.nix

    ./hardware-configuration.nix
  ];

  home-manager = {
    users."roverp" = {...}: {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
        ./../../modules/hm
      ];
    };
  };

  users.users."roverp" = {
    isNormalUser = true;
    initialPassword = "laptop";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    shell = pkgs.zsh;
  };

  # swapDevices = [
  #   {
  #     device = "/.swapvol/swapfile";
  #     size = 32 * 1024;
  #   }
  # ];
  #
  # boot = {
  #   resumeDevice = "/dev/mapper/cryptroot";
  #   kernelParams = [
  #     "resume_offset=<calculated-offset>" # Need to calculate this after install
  #   ];
  # };

  networking.hostName = "erebos";
  time.timeZone = "Europe/Warsaw";

  wisp.boot.systemdBoot = {
    enable = true;
    # enableCryptodisk = true;
  };
}
