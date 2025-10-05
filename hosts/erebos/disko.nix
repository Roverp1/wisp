{device ? throw "Set to your disk device (e.g. /dev/sda)"}: {
  disko.devices.disk = {
    main = {
      type = "disk";
      device = device;

      content = {
        type = "gpt";

        partitions = {
          esp = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };

          # LUKS-encrypted Btrfs partition
          luks = {
            # start with 90% and increase if needed?
            size = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              settings = {
                allowDiscards = true;
                # keyFile = null;
              };
              extraFormatArgs = [
                "--perf-no_read_workqueue"
                "--perf-no_write_workqueue"
              ];

              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # force

                subvolumes = let
                  options = ["compress=zstd" "noatime"];
                in {
                  "root" = {
                    mountpoint = "/";
                    mountOptions = options;
                  };
                  "home" = {
                    mountpoint = "/home";
                    mountOptions = options;
                  };
                  "nix" = {
                    mountpoint = "/nix";
                    mountOptions = options;
                  };
                  "snapshots" = {
                    mountpoint = "/snapshots";
                    mountOptions = options;
                  };

                  "swap" = {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "32G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
