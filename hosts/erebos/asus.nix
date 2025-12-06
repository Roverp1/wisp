{pkgs, ...}: {
  services = {
    supergfxd.enable = true;

    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];
}
