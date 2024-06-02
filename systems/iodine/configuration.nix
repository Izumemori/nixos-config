{ 
  pkgs,
  inputs,
  config,
  ...
}: {
  networking = {
    hostName = "iodine";
    firewall.enable = false;
  };

  services.fwupd.enable = true;

  system.stateVersion = "24.05";
}