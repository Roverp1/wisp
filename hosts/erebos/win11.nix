{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.wisp.virtualisation.nixvirt;

  xmlTemplate = builtins.readFile ../../Configs/.local/share/backup/vm/win11.xml;

  xmlContent =
    builtins.replaceStrings [
      "/usr/share/edk2/x64/OVMF_CODE.4m.fd"
      "/usr/share/edk2/x64/OVMF_VARS.4m.fd"
      "/usr/bin/qemu-system-x86_64"
    ] [
      "/run/libvirt/nix-ovmf/OVMF_CODE.fd"
      "/run/libvirt/nix-ovmf/OVMF_VARS.fd"
      "${pkgs.qemu_kvm}/bin/qemu-system-x86_64"
    ]
    xmlTemplate;

  xmlFile = pkgs.writeText "win11-domain.xml" xmlContent;
in {
  config = lib.mkIf cfg.enable {
    virtualisation.libvirt.connections."qemu:///system".domains = [
      {
        definition = xmlFile;

        active = null;
        restart = null; # null - restart on xml changes
      }
    ];

    system.activationScripts.libvirt-nvram = ''
      if [[ "$NIXOS_ACTION" = "switch" ]] || [[ "$NIXOS_ACTION" = "build" ]] || [[ "$NIXOS_ACTION" = "test" ]]; then
        NVRAM_DIR="/var/lib/libvirt/qemu/nvram"
        NVRAM_FILE="$NVRAM_DIR/win11_VARS.fd"

        mkdir -p "$NVRAM_DIR"

        if [[ ! -f "$NVRAM_FILE" ]]; then
          if [[ -f "/home/roverp/.local/share/backup/vm/win11_VARS.fd" ]]; then
            ${pkgs.coreutils}/bin/cp /home/roverp/.local/share/backup/vm/win11_VARS.fd "$NVRAM_FILE"

            ${pkgs.coreutils}/bin/chmod 600 "$NVRAM_FILE"
          fi
        fi
      fi
    '';
  };
}
