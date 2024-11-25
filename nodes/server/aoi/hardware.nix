{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath, 
  ... 
}: {
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
      ];

      kernelModules = [ ];
    };
  };


  fileSystems = {
    "/" ={ 
      device = "/dev/nvme0n1p3";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };

    "/home" = { 
      device = "/dev/nvme0n1p3";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };

    "/boot" = { 
      device = "/dev/disk/by-uuid/9795-6FBC";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/nix" = { 
      device = "/dev/nvme0n1p3";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/341a1fb1-355c-41ea-8e83-d16691e8d2bd";
    }
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
  };
}