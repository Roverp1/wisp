{inputs, ...}: {
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

  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix

    ./../modules/system
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };

  networking.wireless.enable = false; # Use NetworkManager instead
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05";
}
