{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.virtualisation;
in {
  options.wisp.virtualisation = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable virtualisation module";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu_kvm;

        runAsRoot = true;
        swtpm.enable = true;

        ovmf = {
          enable = true;
          packages = [pkgs.OVMFFull.fd];
        };
      };
    };

    programs.virt-manager.enable = true;

    users.users.roverp.extraGroups = ["libvirtd"];

    environment.systemPackages = with pkgs; [virtiofsd];
  };
}
