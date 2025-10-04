{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./../default.nix

    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  home-manager = {
    users."erebos" = {...}: {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
        ./../../modules/hm
      ];
    };
  };

  users.users."erebos" = {
    isNormalUser = true;
    initialPassword = "laptop";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    shell = pkgs.zsh;
  };

  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/nvme0n1p3"; # change
      keyFile = null;
      allowDiscards = true;
    };
  };

  swapDevices = [{device = "/dev/nvme0n1p2";}]; # change?

  networking.hostName = "erebos";
  time.timeZone = "Europe/Warsaw";

  wisp.boot.grub.enable = true;
}
