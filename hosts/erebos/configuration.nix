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

  networking.hostName = "erebos";
  time.timeZone = "Europe/Warsaw";
}
