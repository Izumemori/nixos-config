{
  config,
  lib,
  nodeConfig,
  ...
}: let
  cfg = config.services.syncthing;
in { 
  options.services.syncthing = {
    nodeUser = lib.mkOption { 
      type = lib.types.oneOf nodeConfig.users; 
      description = "The user to run syncthing under";  
    };

    port = lib.mkOption {
      type = lib.types.port;
      description = "The port for syncthing";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      description = "Open default ports and gui port";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = rec {
      # Defaults
      openDefaultPorts = lib.mkDefault cfg.openFirewall;
      overrideDevices = lib.mkDefault true;
      overrideFolders = lib.mkDefault true;
      configDir = lib.mkDefault "/home/${cfg.nodeUser.username}/.config/syncthing";
      group = lib.mkDefault config.users.users.${user.content}.group;
      guiAddress = lib.mkDefault "0.0.0.0:${toString cfg.port}";

      user = lib.mkForce cfg.nodeUser.username;      
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; 
  };
}