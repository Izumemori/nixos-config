{ config, customLib, ... }: let lib = customLib; in {
  services.syncthing = {
    enable = true;    
    nodeUser = lib.users.sam;
    port = 8384;
    openFirewall = true;

    key = config.sops.secrets."syncthing-key".path;
    cert = config.sops.secrets."syncthing-cert".path;
    
    settings = {
      folders = {
        "plex" = {
          type = "receiveonly";
          id = "xdtsp-fnbmu";
          path = "/mnt/media/plex";
          devices = [ "carbon" ];
          ignorePerms = true;
        };
      };
      
      devices = {
        "carbon" = {
          id = "UKAZNHZ-XRAHFVL-5O2HRMS-RPE63X6-UKQLBNS-MDK2COK-HYC3G3Z-DUO7VQJ";
        };
      };
    };
  };
}