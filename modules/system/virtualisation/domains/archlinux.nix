{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.wisp.virtualisation.nixvirt;
in {
  config = lib.mkIf cfg.enable {
    virtualisation.libvirt.connections."qemu:///system" = {
      pools = [
        {
          definition = inputs.nixvirt.lib.pool.writeXML {
            name = "vms";
            type = "dir";
            target.path = "/var/lib/libvirt/images/";
          };

          active = true;
          volumes = [
            {
              definition = inputs.nixvirt.lib.volume.writeXML {
                name = "archlinux.qcow2";

                capacity = {
                  count = 40;
                  unit = "GB";
                };

                target.format.type = "qcow2";
              };
            }
          ];
        }
      ];

      domains = [
        {
          definition = inputs.nixvirt.lib.domain.writeXML {
            name = "archlinux";
            uuid = "862dc185-f7c6-4bb1-8b09-4b453abe6cbc";

            memory = {
              count = 6;
              unit = "GiB";
            };

            os = {
              type = {
                value = "hvm";
                arch = "x86_64";
                machine = "pc-q35-8.2";
              };

              loader = {
                readonly = true;
                type = "pflash";
                path = "/run/libvirt/nix-ovmf/OVMF_CODE.fd";
              };

              nvram = {
                template = "/run/libvirt/nix-ovmf/OVMF_VARS.fd";
                path = "/var/lib/libvirt/qemu/nvram/archlinux_VARS.fd";
              };

              boot = [
                {dev = "cdrom";}
                {dev = "hd";}
              ];
            };

            vcpu = {
              count = 6;
              placement = "static";
            };

            cpu = {
              mode = "host-passthrough";
              check = "none";
              migratable = true;

              topology = {
                sockets = 1;
                dies = 1;
                cores = 3;
                threads = 2;
              };
            };

            clock = {
              offset = "utc";

              timer = [
                {
                  name = "rtc";
                  tickpolicy = "catchup";
                }
                {
                  name = "pit";
                  tickpolicy = "delay";
                }
                {
                  name = "hpet";
                  present = false;
                }
              ];
            };

            features = {
              acpi = {};
              apic = {};
            };

            on_poweroff = "destroy";
            on_reboot = "restart";
            on_crash = "destroy";

            devices = {
              emulator = "${pkgs.qemu_kvm}/bin/qemu-system-x86_64";

              disks = [
                {
                  type = "volume";
                  device = "disk";

                  driver = {
                    name = "qemu";
                    type = "qcow2";
                  };

                  source = {
                    pool = "vms";
                    volume = "archlinux.qcow2";
                  };

                  target = {
                    dev = "vda";
                    bus = "virtio";
                  };
                }

                {
                  type = "file";
                  device = "cdrom";
                  readonly = true;

                  driver = {
                    name = "qemu";
                    type = "raw";
                  };

                  source.file = /home/roverp/Downloads/archlinux.iso;

                  target = {
                    dev = "sda";
                    bus = "sata";
                  };
                }
              ];

              interfaces = [
                {
                  type = "network";
                  source.network = "default";
                  model.type = "virtio";
                }
              ];

              graphics = [
                {
                  type = "spice";
                  autoport = true;
                }
              ];

              video = [
                {
                  model = {
                    type = "qxl";

                    ram = 65536;
                    vram = 65536;
                    heads = 1;
                  };
                }
              ];

              input = [
                {
                  type = "keyboard";
                  bus = "ps2";
                }
                {
                  type = "mouse";
                  bus = "ps2";
                }
              ];
            };
          };
          active = null;
          restart = false;
        }
      ];
    };
  };
}
