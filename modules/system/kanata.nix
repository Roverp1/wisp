{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.kanata;
in {
  options.wisp.kanata = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable kanata system module (sets required permissions for kanata home module)";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.uinput = {};
    users.users."roverp".extraGroups = ["input" "uinput"];

    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';

    boot.kernelModules = ["uinput"];
  };
}
