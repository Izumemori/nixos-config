{ config, pkgs, customLib, nodeConfig, ... }: let lib = customLib; in {
  proxmox= {
    qemuConf = {
      virtio0 = "local-btrfs:vm-100-disk-0"; # Hint target storage
      cores = 2;
      memory = 2048; # 2GiB
      bios = "ovmf"; # EFI Support
      name = nodeConfig.hostname;
      additionalSpace = "10G";
      bootSize = "512M";
    };

    cloudInit = {
      enable = false;
      defaultStorage = "local-btrfs";
    };

    qemuExtraConf = {
      machine = "q35";
      localtime = 0;
    };
  };

  services.qemuGuest.enable = true;
}