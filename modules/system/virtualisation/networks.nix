{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.wisp.virtualisation.nixvirt;
in {
  config = lib.mkIf cfg.enable {
    virtualisation.libvirt.connections."qemu:///system".networks = [
      {
        definition = inputs.nixvirt.lib.network.writeXML {
          name = "default";
          uuid = "cdec1cf9-8ba3-4518-b659-c75e61519c08";

          forward = {
            mode = "nat";
            nat = {
              port = {
                start = 1024;
                end = 65535;
              };
            };
          };

          bridge = {name = "virbr0";};
          mac = {address = "52:54:00:02:77:4b";};

          ip = {
            address = "192.168.74.1";
            netmask = "255.255.255.0";

            dhcp = {
              range = {
                start = "192.168.74.2";
                end = "192.168.74.254";
              };
            };
          };
        };

        active = true;
      }
    ];
  };
}
