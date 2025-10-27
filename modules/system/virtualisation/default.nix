{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.wisp.virtualisation;
in {
  imports = [
    inputs.nixvirt.nixosModules.default
    ./networks.nix
    ./domains/win11.nix
  ];

  options.wisp.virtualisation = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable virtualisation module";
    };

    nixvirt = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Enable nixvirt configuration";
      };

      win11.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable windows11 virtual machine";
      };
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
