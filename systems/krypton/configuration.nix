{ 
  pkgs,
  inputs,
  config,
  ...
}: {
  networking = {
    hostName = "krypton";
    firewall.enable = true;
  };

  services = {
    vfio = {
      enable = true;
      pciIDs = [
        "10de:2484"
        "10de:228b"
      ];
      storagePath = "/home/sam/.vm/storage/";
      nvramPath = "/home/sam/.vm/nvram/";
    };
  };

  system.stateVersion = "24.05";
}
