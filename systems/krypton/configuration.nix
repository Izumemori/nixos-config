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
    };
  };

  system.stateVersion = "24.05";
}
