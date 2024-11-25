{
  inputs',
  self',
  self,
  config,
  lib,
  nodeConfig,
  ...
}: { 
  options.services.plex = {
    nodeUser = lib.mkOption { 
      type = lib.types.oneOf nodeConfig.users; 
      description = "The user to run plex under";  
    };
  };

  config = lib.mkIf config.services.plex.enable {
    services.plex = {
      openFirewall = true;
      user = lib.mkForce config.services.plex.nodeUser.name;
    };
  };
}