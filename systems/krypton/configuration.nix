{ 
  pkgs,
  inputs,
  config,
  ...
}: {
  networking = {
    hostName = "krypton";
    firewall.enable = true;
    hostId = "12345678";
  };

  environment.systemPackages = with pkgs; [
    corectrl
  ];

  services = {
    vfio = {
      enable = true;
      pciIDs = [
        "10de:2484"
        "10de:228b"
      ];
      isosPath = "/home/sam/.vm/isos/";
      storagePath = "/home/sam/.vm/storage/";
      nvramPath = "/home/sam/.vm/nvram/";
      user = "sam";
      kvmfr.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
