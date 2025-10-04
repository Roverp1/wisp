{
  disko.devices = {
    main = {
      type = "disk";
      device = "/dev/nvme0n1";

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

          swap = {
            size = "32G";
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true;
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
                allowDiscrads = true;
                keyFile = null;
              };

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
                };
              };
            };
          };
        };
      };
    };
  };
}
