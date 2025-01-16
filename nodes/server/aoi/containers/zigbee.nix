{ config, pkgs, lib, ... }: {

  services = {
    zigbee2mqtt = {
      enable = true;
      settings = {
        
      };
    };
  };

  system.stateVersion = "24.11";
}