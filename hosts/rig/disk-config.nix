# ext4 + swap

{
  disko.devices = {
    disk = {
      # SSD (128GiB)
      disk0 = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            swap = {
              size = "8G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };

            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };

      # HDD (1 TiB)
      disk1 = {
        device = "/dev/sdb";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {

            home = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";
              };
            };
          };
        };
      };
    };
  };
}
