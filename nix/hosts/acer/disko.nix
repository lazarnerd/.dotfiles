{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-diskseq/1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              label = "boot";
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" "defaults" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/nixos/root" = {
                    mountpoint = "/";
                    mountOptions = ["subvol=nixos/root" "compress=zstd" "noatime"];
                  };
                  "/nixos/home" = {
                    mountpoint = "/home";
                    mountOptions = ["subvol=nixos/home" "compress=zstd" "noatime"];
                  };
                  "/nixos/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["subvol=nixos/nix" "compress=zstd" "noatime"];
                  };
                  "/swap" = {
                    mountpoint = "/swap";
                    swap.swapfile.size = "16G";
                  };
                };

                # mountpoint = "/partition-root";
                # swap = {
                #   swapfile = {
                #     size = "16G";
                #   };
                # };
              };
            };
          };
        };
      };
    };
  };
}
